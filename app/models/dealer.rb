class Dealer < ActiveRecord::Base

  acts_as_paranoid

  geocoded_by :address
  after_validation :geocode

  has_many :operation_codes
  has_many :labor_types
  has_many :postal_codes
  has_many :dealer_years
  has_many :vehicle_years, :through => :dealer_years
  has_many :dealer_makes
  has_many :vehicle_makes, :through => :dealer_makes
  has_many :dealer_models
  has_many :vehicle_models, :through => :dealer_models

  extend FriendlyId
  friendly_id :dealer_name, use: :slugged

  validates_uniqueness_of :dealer_focus_id, :allow_blank => true, :allow_nil => true

  validates_presence_of :dealer_name
  validates_uniqueness_of :dealer_name
  validates_uniqueness_of :dealer_focus_id, :allow_blank => true, :allow_nil => true

  after_validation :create_full_address
  after_validation :set_lat_lng
  after_validation :set_timezone

  has_many :customers, :dependent => :destroy
  has_many :services, :through => :customers
  has_many :sales, :through => :customers
  has_many :appointments, :through => :customers
  has_many :vehicles, :through => :customers
  has_many :events, :dependent => :destroy
  has_many :s3files

  scope :active_dealers , -> { where("dealers.dealer_status IS TRUE").order("dealer_name ASC") }

  has_many :providers do
    def bank
      where(:provider_type => :bank)
    end

    def warranty
      where(:provider_type => :warranty)
    end
  end

  def self.find_with_campaign(campaign_id)
    begin
      campaign = Campaign.find(campaign_id)
      return campaign.dealer
    rescue
      return false
    end
  end

  def self.get_dealers(options = {})
    dealers = {}
    page_num = (options[:page] || 1).to_i
    per_page = 25

    if options[:dealer_id].present? && options[:dealer_id].to_i > 0
      dealer_ids = []
    else
      dealer_ids = Dealer.all.map(&:id)
    end

    filtered_dealers = Dealer.search_with_postgres(options, dealer_ids).order("#{options[:sortBy]} #{options[:sortableDirection]}")

    dealers[:data] = Kaminari.paginate_array(filtered_dealers).page(page_num).per(per_page)

    if dealers[:data].present? && dealers[:data].count > 0
      dealers[:data] = Dealer.dealer_map(dealers[:data])
    end

    dealers[:pagination] = Dealer.pagination_data filtered_dealers.count, page_num, per_page

    return dealers
  end

  # This paginates all of the data for the response of the js.
  def self.pagination_data element_count, current_page, results_per_page
    page  = current_page.to_i
    pages = (element_count / results_per_page.to_f).ceil

    if pages <= 1
      pages = 1
      relevant_pages = []
    else
      # If possible, add the two previous and two next pages to the 'relevant pages' array
      previous_pages = page - 2 < 1 ? (1..page).to_a : ( (page - 2)..page ).to_a
      next_pages     = page + 2 > pages ? ( (page+1)..pages ).to_a : ( (page+1)..(page + 2) ).to_a
      relevant_pages = previous_pages + next_pages

      # Add the first and last page to the 'relevant pages' array if they are not present
      relevant_pages.unshift(1) unless relevant_pages.first == 1
      relevant_pages << pages   unless relevant_pages.last == pages
    end

    { total_items: element_count, pages: pages, relevant_pages: relevant_pages }
  end

  def self.search_with_postgres(options={}, dealer_ids)

    sql_string = []

    dealers = []

    if options[:dealer_id].present? && options[:dealer_id].size > 0
      sql_string << "(CAST(id AS TEXT) LIKE '%#{options[:dealer_id]}%')"
    end

    if options[:dealer_name].present? && options[:dealer_name].size > 0
      sql_string << "(dealer_name ILIKE '%#{options[:dealer_name]}%')"
    end

    if options[:dealer_focus_id].present? && options[:dealer_focus_id].size > 0
      sql_string << "(CAST(dealer_focus_id AS TEXT) LIKE '%#{options[:dealer_focus_id]}%')"
    end

    final_sql_string = sql_string.count > 1 ? sql_string.join(' AND ') : sql_string[0]

    if final_sql_string.present? && final_sql_string.size > 0 && options[:dealer_id].present? && options[:dealer_id].size > 0
      dealers = Dealer.where("(#{final_sql_string})")
    elsif final_sql_string.present? && final_sql_string.size > 0
      dealers = Dealer.where("id IN (?) AND (#{final_sql_string})", dealer_ids)
    else
      dealers = Dealer.where("id IN (?)", dealer_ids)
    end

    dealers
  end

  # Required - Array of dealers
  # Returns mapped attributes of dealers
  def self.dealer_map(dealer_array)
    if dealer_array.present? && dealer_array.count > 0
      dealers = dealer_array.map{ |dealer| {
        dealer_id:         dealer.id,
        dealer_focus_id:   dealer.dealer_focus_id,
        dealer_name:       dealer.dealer_name,
        dealer_status:     dealer.get_dealer_status,
        vendor:            dealer.vendor,
        scheduler_name:    dealer.get_scheduler,
        scheduler_account: dealer.scheduler_account,
        lat_lng:           dealer.lat_lng
        } 
      }
    else
      dealers = []
    end

    dealers
  end

  def get_dealer_status
    if self.dealer_status.present? && self.dealer_status == true
      status = 'Active'
    else
      status = 'Inactive'
    end

    status
  end

  def get_scheduler
    if self.service_scheduler.present? && self.service_scheduler.scheduler_name.present? && self.service_scheduler.scheduler_name.size > 0
      scheduler_name = self.service_scheduler.scheduler_name
    else
      scheduler_name = nil
    end

    scheduler_name
  end
  
  def hasCampaign?(campaign_id)
    campaigns.each do |campaign|
      if campaign.id == campaign_id
        return true
      end
    end
    
    false
  end

  def dms_imports_complete?

    d = self

    today_moved = d.s3files.where('DATE(created_at) = DATE(NOW()) AND status = ?', 'moved')

    today_registered = d.s3files.where('DATE(created_at) = DATE(NOW()) AND status = ?', 'registered')

    if today_moved.count > 0 && today_registered.count == 0
      true
    else
      false
    end
  end

  def isAsr?
    is_asr == true
  end

  def push_to_freshbooks
    config = YAML.load_file(Rails.root+'config/application.yml')[Rails.env]

    freshbooks_client = FreshBooks::Client.new(config["FRESHBOOKS_URL"], config["FRESHBOOKS_API_TOKEN"])

    dealer = freshbooks_client.client.create(client: {first_name: self.accounting_first_name, last_name: self.accounting_last_name, organization: self.dealer_name, email: self.accounting_email})

    if dealer["client_id"]
      self.update(freshbooks_client_key: dealer["client_id"])
    end
  end

  def compatible_scheduler
    compatibles = ['AutoLoop', 'Atom']

    coordinators = ['3', 'Coordinators']

    coordinator_appts = self.appointments.where('sub_category IN (?)', coordinators).count

    if (compatibles.include? (self.service_scheduler.scheduler_name)) && coordinator_appts > 0
      return true
    else
      return false
    end
  end

  def create_full_address
    unless self.try(:address_1).nil? || self.try(:postal_code).nil? || self.try(:state_province).nil?
      self.address = "#{self.address_1} #{self.address_2} #{self.city_region} #{self.state_province} #{self.postal_code}"
    end
  end

  def set_lat_lng
    unless self.try(:latitude).nil? || self.try(:longitude).nil?
      self.lat_lng = "#{self.latitude},#{self.longitude}"
    end
  end

  def set_timezone
    if self.address && self.address.size > 0 && self.latitude && self.longitude
      timezone = Timezone::Zone.new :latlon => [self.latitude, self.longitude]

      if timezone
        self.time_zone = timezone.active_support_time_zone
      end
    end
  end

  def copy_dealer(target_dealer_id)
    if self.campaigns.count > 0
      self.campaigns.each do |campaign|
        c = campaign.dup

        c.assign_attributes(
            :dealer_id => target_dealer_id,
            :call_queue_id => nil,
            :phone_number => nil
        )

        c.save
      end
    end

    #   promotions, special_instructions
    if self.promotions.count > 0
      self.promotions.each do |promotion|
        p = promotion.dup

        p.assign_attributes(
            :dealer_id => target_dealer_id
        )

        p.save
      end
    end

    if self.special_instructions.count > 0
      self.special_instructions.each do |special_instruction|
        s = special_instruction.dup

        s.assign_attributes(
            :dealer_id => target_dealer_id
        )

        s.save
      end
    end

  end

  def self.nuke_dealer(dealer_id)

    dealer = Dealer.find(dealer_id)

    #  this will nuke all of the things attached to a dealer

    CallRecord.delete_all(:dealer_id => dealer.id)

    dealer.campaigns.each do |campaign|
      SurveyAttempt.delete_all(:campaign_id => campaign.id)

      campaign.surveys.find_each do |survey|
        survey.destroy
      end

      CampaignCustomer.delete_all(:campaign_id => campaign.id)

      Campaign.delete_all(:dealer_id => dealer.id)

    end

    dealer.users.delete_all

    dealer.employees.delete_all

    dealer.departments.delete_all

    dealer.prospects.each do |prospect|

      prospect.prospect_appointments.delete_all

      prospect.prospect_notes.delete_all

      prospect.prospect_vehicles.delete_all

      prospect.prospect_appointments.delete_all

      prospect.destroy
    end

    Service.delete_all(:dealer_id => dealer.id)

    Sale.delete_all(:dealer_id => dealer.id)

    Appointment.delete_all(:dealer_id => dealer.id)

    Event.delete_all(:dealer_id => dealer.id)

    dealer.customers.each do |customer|

      CustomerVehicle.where(:customer_id => customer.id).each do |vehicle|
        begin
          Vehicle.destroy(vehicle.id)
          vehicle.destroy
        rescue
          puts 'error finding vehicle'
        end
      end

      CustomerVersion.delete_all(:item_id => customer.id)

    end

    Customer.delete_all(:dealer_id => dealer.id)

    dealer.quick_prospects.delete_all

    # now finally we can destroy the dealer

    DealerVersion.delete_all(:item_id => dealer.id)

    dealer.destroy

  end

  def create_setup_tasks
    tasks = SetupTask.all

    tasks.each do |task|
      DealerSetup.create(:setup_task_id => task.id, :dealer_id => self.id, :priority => task.priority)
    end
  end

  def updated_status(options={})

    User.where(:system_alerts => true).each do |user|
      # Notifier.send_dealer_status_change(options, self, user).deliver
      SendgridMailer.send_dealer_status_change(options, self, user).deliver
    end
  end

  def body_shop_policy

    body_shop = SpecialInstructionType.where(:type_name => "Body Shop Estimate Policy").first

    if body_shop.nil?
      result = "N/A"
    else
      body_shop_instruction = self.special_instructions.where(:special_instruction_type_id => body_shop.id).first

      result = body_shop_instruction ? body_shop_instruction.instruction_text : 'N/A'
    end
    result
  end

  def active_campaigns
    self.campaigns.where(is_active: true)
  end

  def prepare_employee_data
    self.employees.joins(:user).order("users.first_name ASC").map { |employee| {
        :employee_id           => employee.id,
        :employee_name         => employee.user.full_name,
        :employee_phone_number => employee.direct_inward_dial
    }
    }
  end

  def prepare_department_data
    self.departments.order("department_name ASC").map { |department| {
        :department_id           => department.id,
        :department_name         => department.department_name,
        :department_phone_number => department.phone_number
    }
    }
  end

  def prepare_dealer_information
    result = {
        :dealer_id => self.id,
        :dealer_name => self.dealer_name,
        :address_1 => self.address_1,
        :address_2 => self.address_2,
        :city_region => self.city_region,
        :state_province => self.state_province,
        :postal_code => self.postal_code,
        :time_zone => self.time_zone,
        :lat_lng => self.lat_lng,
        :service_scheduler => self.service_scheduler.scheduler_name,
        :website_address => self.website_address,
        :pronunciation => self.dealer_name_pronunciation
    }

    result
  end

  def prepare_policy_data
    result = {
        :shuttle_policy => self.shuttle_policy,
        :rental_policy => self.rental_policy,
        :loaner_policy => self.loaner_policy,
        :roadside_assistance_policy => self.roadside_assistance_policy,
        :misc_instructions => self.misc_instructions,
        :emergency_contacts => self.emergency_contacts,
        :dealer_benefits => self.dealer_benefits,
        :diagnostic_policy => self.diagnostic_policy,
        :night_drop_policy => self.night_drop_policy,
        :latest_pickup_policy => self.latest_pickup_policy,
        :recall_policy => self.recall_policy

    }
    result
  end

  def shuttle_policy

    shuttle = SpecialInstructionType.where(:type_name => "Shuttle Service Policy").first
    if shuttle.nil?
      result = "N/A"
    else
      shuttle_instruction = self.special_instructions.where(:special_instruction_type_id => shuttle.id).first
      result = shuttle_instruction ? shuttle_instruction.instruction_text : 'N/A'
    end
    result
  end

  def rental_policy

    rental = SpecialInstructionType.where(:type_name => "Rental Car Policy").first
    if rental.nil?
      result = "N/A"
    else
      rental_instruction = self.special_instructions.where(:special_instruction_type_id => rental.id).first
      result = rental_instruction ? rental_instruction.instruction_text : 'N/A'
    end
    result
  end

  def loaner_policy

    loaner = SpecialInstructionType.where(:type_name => "Loaner Car Policy").first
    if loaner.nil?
      result = "N/A"
    else
      loaner_instruction = self.special_instructions.where(:special_instruction_type_id => loaner.id).first
      result = loaner_instruction ? loaner_instruction.instruction_text : 'N/A'
    end
    result
  end

  def roadside_assistance_policy

    roadside = SpecialInstructionType.where(:type_name => "Roadside Assistance").first
    if roadside.nil?
      result = "N/A"
    else
      roadside_instruction = self.special_instructions.where(:special_instruction_type_id => roadside.id).first
      result = roadside_instruction ? roadside_instruction.instruction_text : 'N/A'
    end
    result
  end

  def misc_instructions

    misc = SpecialInstructionType.where(:type_name => "Misc").first
    if misc.nil?
      result = "N/A"
    else
      misc_instruction = self.special_instructions.where(:special_instruction_type_id => misc.id).first
      result = misc_instruction ? misc_instruction.instruction_text : 'N/A'
    end
    result
  end

  def emergency_contacts

    emergency = SpecialInstructionType.where(:type_name => "Emergency Contacts").first

    if emergency.nil?
      result = "N/A"
    else
      emergency_contact = self.special_instructions.where(:special_instruction_type_id => emergency.id).first

      result = emergency_contact ? emergency_contact.instruction_text : 'N/A'
    end

    result
  end

  def dealer_benefits
    benefits = SpecialInstructionType.where(:type_name => "Dealer Benefits").first

    if benefits.nil?
      result = "N/A"
    else
      benefit_instruction = self.special_instructions.where(:special_instruction_type_id => benefits.id).first

      result = benefit_instruction ? benefit_instruction.instruction_text : 'N/A'
    end
    result
  end

  def diagnostic_policy

    diagnostic = SpecialInstructionType.where(:type_name => "Diagnostic Policy").first

    if diagnostic.nil?
      result = "N/A"
    else
      diagnostic_instruction = self.special_instructions.where(:special_instruction_type_id => diagnostic.id).first

      result = diagnostic_instruction ? diagnostic_instruction.instruction_text : 'N/A'
    end
    result
  end


  def night_drop_policy

    night_drop = SpecialInstructionType.where(:type_name => "Night Drop").first

    if night_drop.nil?
      result = "N/A"
    else
      night_drop_instruction = self.special_instructions.where(:special_instruction_type_id => night_drop.id).first

      result = night_drop_instruction ? night_drop_instruction.instruction_text : 'N/A'
    end
    result
  end

  def latest_pickup_policy

    latest_pickup = SpecialInstructionType.where(:type_name => "Latest Pickup").first

    if latest_pickup.nil?
      result = "N/A"
    else
      latest_pickup_instruction = self.special_instructions.where(:special_instruction_type_id => latest_pickup.id).first

      result = latest_pickup_instruction ? latest_pickup_instruction.instruction_text : 'N/A'
    end
    result
  end

  def recall_policy
    recall = SpecialInstructionType.where(:type_name => "Recalls").first
    if recall.nil?
      result = "N/A"
    else
      recall_instruction = self.special_instructions.where(:special_instruction_type_id => recall.id).first

      result = recall_instruction ? recall_instruction.instruction_text : 'N/A'
    end
    result
  end

  def get_operation_codes
    self.operation_codes.map(&:name).uniq
  end

  def update_counts
    self.update(
        :appointments_count   =>  self.appointments.count,
        :services_count       =>  self.services.count,
        :sales_count          =>  self.sales.count,
        :prospects_count      =>  self.prospects.count
    )
  end

  def first_group
    unless self.groups.count == 0
      self.groups.first.group_name
    end
  end

  scope :complex_search , -> (params) {where("dealer_name ILIKE :q OR dealer_focus_id ILIKE :q OR vendor ILIKE :q", q: "%#{params[:complex_search]}%") }
end