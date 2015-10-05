class Customer < ActiveRecord::Base

  # there are 2 triggers on customer in PG that set phone_number

  acts_as_paranoid

  belongs_to :dealer

  has_many :services, :dependent => :destroy
  has_many :appointments, :dependent => :destroy
  has_many :sales, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :customers_vehicles, class_name: 'CustomerVehicle'
  has_many :vehicles, through: :customers_vehicles

  # callbacks to cleanup data
  before_save :cleanup_phones
  before_save :cleanup_emails
  before_save :create_postal_code
  before_save :set_full_name
  before_validation :check_valid_phones

  attr_accessor :survey_vehicle_info,
                :customer_name,
                :customer_email,
                :customer_phone,
                :customer_address,
                :customer_vin

  # denotes the method by which we matched
  enum match_type: {customer_matcher: 1, simple_matcher: 2}

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
  # Convenience search methods
  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  def self.search_with_postgres(options={}) #the options hash expects "dealer_id" "customer_name," "customer_email," "customer_phone," and "customer_address"
    # dealer = Dealer.find options[:dealer_id]

    # customers = dealer.customers.where(options.except(*:dealer_id).permit(:first_name, :last_name, :email_address_1, :home_phone, :work_phone, :cell_phone, :address_1))

    sql_string = []

    customers = []

    if options[:first_name].present? && options[:first_name].size > 0
      sql_string << "(first_name ILIKE '%#{options[:first_name]}%')"
    end

    if options[:last_name].present? && options[:last_name].size > 0
      sql_string << "(last_name ILIKE '%#{options[:last_name]}%')"
    end

    if options[:customer_email].present? && options[:customer_email].size > 0
      sql_string << "(email_address_1 ILIKE '%#{options[:customer_email]}%' OR email_address_2 ILIKE '%#{options[:customer_email]}%')"
    end

    if options[:customer_phone].present? && options[:customer_phone].size > 0
      sql_string << "(home_phone ILIKE '%#{options[:customer_phone]}%' OR work_phone ILIKE '%#{options[:customer_phone]}%' OR cell_phone ILIKE '%#{options[:customer_phone]}%')"
    end

    if options[:customer_address].present? && options[:customer_address].size > 0
      sql_string << "(address_1 ILIKE '%#{options[:customer_address]}%' OR address_2 ILIKE '%#{options[:customer_address]}%' OR city_region ILIKE '%#{options[:customer_address]}%' OR state_province ILIKE '%#{options[:customer_address]}%' OR postal_code ILIKE '%#{options[:customer_address]}%')"
    end

    final_sql_string = sql_string.count > 1 ? sql_string.join(' AND ') : sql_string[0]

    if options[:vin].present? && options[:vin].size > 0 && final_sql_string.present? && final_sql_string.size > 0
      customers = Customer.joins("inner join customers_vehicles ON customers_vehicles.customer_id = customers.id").joins("inner join vehicles ON vehicles.id = customers_vehicles.vehicle_id").where("dealer_id = ? AND (#{final_sql_string}) AND vehicles.vin ILIKE '%#{options[:vin]}%'", options[:dealer_id])
    end

    if options[:vin].present? && options[:vin].size > 0
      customers = Customer.joins("inner join customers_vehicles ON customers_vehicles.customer_id = customers.id").joins("inner join vehicles ON vehicles.id = customers_vehicles.vehicle_id").where("dealer_id = ? AND vehicles.vin ILIKE '%#{options[:vin]}%'", options[:dealer_id])
    end

    if final_sql_string.present? && final_sql_string.size > 0
      customers = Customer.where("dealer_id = ? AND (#{final_sql_string})", options[:dealer_id])
    end

    customers
  end

  def self.search_by_phone(dealer, phone_number)
    dealer.customers.where('home_phone = ? OR work_phone = ? OR cell_phone = ?', phone_number, phone_number, phone_number)
  end

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
  # Matching Method Elements
  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  def self.find_with_postgres(options = {}) #master finder method
    if options[:dealer_id].present? && Dealer.find(options[:dealer_id]).is_a?(Dealer)
      puts "----- theoptions -------"
      puts options

      customers = Customer.where(options)

      if customers && customers.count > 0 && customers.first.is_a?(Customer)
        customer = customers.first
      else
        customer = nil
      end

      return customer
    else
      return false
    end
  end

  def self.match_or_create(options = {})

    Customer.where(options).first_or_create

  end

  def assign_to_parent
    if self.parent_id.present? && self.parent_id > 0
      # vehicles
      customer_vehicles = CustomerVehicle.where(customer_id: self.id)

      if customer_vehicles && customer_vehicles.count > 0
        customer_vehicles.each do |cv|
          # need to account for vehicles that are the same as the parent as well as those that aren't the same
          pv = CustomerVehicle.where(customer_id: self.parent_id, vehicle_id: cv.vehicle_id).first_or_create

          # appointments
          appts = Appointment.where(customer_id: self.id, customer_vehicle_id: cv.id)

          appts.each do |appointment|
            appointment.update(customer_id: self.parent_id, customer_vehicle_id: pv.id)

            appointment.event.update(customer_id: self.parent_id, customer_vehicle_id: pv.id)
          end

          # sales
          sls = Sale.where(customer_id: self.id, customer_vehicle_id: cv.id)

          sls.each do |sale|
            sale.update(customer_id: self.parent_id, customer_vehicle_id: pv.id)

            sale.event.update(customer_id: self.parent_id, customer_vehicle_id: pv.id)
          end

          # services
          svcs = Service.where(customer_id: self.id, customer_vehicle_id: cv.id)

          svcs.each do |service|
            service.update(customer_id: self.parent_id, customer_vehicle_id: pv.id)

            service.event.update(customer_id: self.parent_id, customer_vehicle_id: pv.id)
          end

          # sale data
          sld = SaleDatum.where(customer_vehicle_id: cv.id)

          sld.each do |sale_data|
            sale_data.update(customer_vehicle_id: pv.id)
          end

          # campaign run customer
          crc = CampaignRunCustomer.where(customer_id: self.id, customer_vehicle_id: cv.id)

          crc.each do |campaign_run_customer|
            campaign_run_customer.update(customer_id: self.parent_id, customer_vehicle_id: pv.id)
          end

          # campaign customer
          cc = CampaignCustomer.where(customer_id: self.id)

          cc.each do |campaign_customer|
            campaign_customer.update(customer_id: self.parent_id)
          end

          cv.destroy

          pv.set_calculated_fields
          pv.estimate_mileage
          pv.save!
        end
      end

      # calls
      cls = Call.where(customer_id: self.id)

      cls.each do |call|
        call.update(customer_id: self.parent_id)

        call.event.update(customer_id: self.parent_id)
      end

      # prospects
      pros = Prospect.where(customer_id: self.id)

      pros.each do |prospect|
        prospect.update(customer_id: self.parent_id)
      end

      # survey alerts
      sva = SurveyAlert.where(customer_id: self.id)

      sva.each do |survey_alert|
        survey_alert.update(customer_id: self.parent_id)
      end

      # survey attempts
      svat = SurveyAttempt.where(customer_id: self.id)

      svat.each do |survey_attempt|
        survey_attempt.update(customer_id: self.parent_id)
      end

      # surveys
      sv = Survey.where(customer_id: self.id)

      sv.each do |survey|
        survey.update(customer_id: self.parent_id)
      end

      #upload customers
      uc = UploadCustomer.where(customer_id: self.id)

      uc.each do |upload_customer|
        upload_customer.update(customer_id: self.parent_id)
      end
    end
  end

  def merge_and_delete_children
    if match_eligible?
      self.find_parent_customer
    else
      customer_id = self.id

      customers_to_delete = []

      if self.parent_id > 0 && self.assign_to_parent
        customers_to_delete << self.id
      elsif self.parent_id == 0
        Customer.where(parent_id: customer_id).each do |child|
          if child.assign_to_parent
            customers_to_delete << child.id
          end
        end

        update(processing: false)
      end

      if customers_to_delete.count > 0
        ActiveRecord::Base.connection.execute("DELETE FROM customers WHERE id = ANY(ARRAY[#{customers_to_delete.join(',')}])")
      end
    end
  end

  def match_eligible?
    self.matched_at.nil? || self.matched_at < Date.today - 5.days
  end

  def find_parent_customer
    if match_eligible? && !processing?
      set_parent_id
    end
  end

  def set_parent_id

    if self.matchable?

      match = Customer.find_with_postgres(self.create_match_hash)
      match_typer = :customer_matcher
    else

      match = Customer.where(self.create_match_hash).first
      match_typer = :simple_matcher
    end

    if match && match.id == self.id

      # customer is the parent
      self.parent_id = 0

    elsif match && match != self.id

      # set the parent id of the customer to the best match
      self.parent_id = match.id

    else
      self.parent_id = 0
    end

    self.match_type = match_typer
    self.matched_at = Time.now
    self.save!

    if merge_and_delete_children
      return true
    else
      return false
    end
  end

  def create_match_string
    self.create_match_hash.except(*:dealer_id).map { |k, v| v }.join(' ')
  end

  def create_match_hash
    match_hash = {}

    match_hash[:first_name] = self.first_name if self.first_name
    match_hash[:last_name] = self.last_name if self.last_name
    match_hash[:cell_phone] = self.cell_phone if self.cell_phone
    match_hash[:work_phone] = self.work_phone if self.work_phone
    match_hash[:home_phone] = self.home_phone if self.home_phone
    match_hash[:email_address_1] = self.email_address_1 if self.email_address_1
    match_hash[:email_address_2] = self.email_address_2 if self.email_address_2
    match_hash[:address_1] = self.address_1 if self.address_1
    match_hash[:city_region] = self.city_region if self.city_region
    match_hash[:state_province] = self.state_province if self.state_province
    match_hash[:postal_code] = self.postal_code if self.postal_code
    match_hash[:dealer_id] = self.dealer_id

    return match_hash
  end

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  def contactable?
    self.has_phone? || self.email_address_1.present? || self.email_address_2.present?
  end

  def has_phone?
    if phone_number.present? && phone_number.count > 0
      return true
    elsif home_phone.present? || work_phone.present? || cell_phone.present?
      phones_array = [home_phone, work_phone, cell_phone].compact
      update!(phone_number: phones_array)
      return true
    else
      return false
    end
  end

  def mailable?
    self.has_names? && self.address_1.present? && self.city_region.present? && self.postal_code.present? && self.state_province.present?
  end

  def has_names?
    self.first_name.present? || self.last_name.present?
  end

  def matchable?
    if self.has_names?
      if self.contactable? || self.mailable?
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def open_campaigns
    campaign_customers = CampaignCustomer.find_by_sql(
        "SELECT campaigns_customers.*
              FROM campaigns_customers
              INNER JOIN campaigns ON campaigns.id = campaigns_customers.campaign_id
              INNER JOIN customers ON customers.id = campaigns_customers.customer_id
              LEFT JOIN surveys ON surveys.campaign_customer_id = campaigns_customers.id
              WHERE campaigns_customers.customer_id = #{self.id}
                AND (customers.do_not_contact_flag != true
                      OR customers.do_not_contact_flag IS NULL)
                AND campaigns.is_active = true
                AND surveys.id IS NULL
                AND campaigns_customers.is_completed IS false
                AND campaigns_customers.eligible_for_outbound IS true
                AND campaigns_customers.attempt_count < campaigns.max_attempts"
    )

    if campaign_customers && campaign_customers.count > 0
      return campaign_customers
    else
      return false
    end
  end

  def cleanup_phones
    if self.home_phone
      home_phone_value = self.home_phone.to_s.gsub(/[^0-9]/, '')

      if home_phone_value[0] == '1' || home_phone_value[0] == '0' || home_phone_value.size != 10
        self.home_phone = nil
      else
        self.home_phone = home_phone_value
      end
    end

    if self.cell_phone
      cell_phone_value = self.cell_phone.to_s.gsub(/[^0-9]/, '')

      if cell_phone_value[0] == '1' || cell_phone_value[0] == '0' || cell_phone_value.size != 10
        self.cell_phone = nil
      else
        self.cell_phone = cell_phone_value
      end
    end

    if self.work_phone
      work_phone_value = self.work_phone.to_s.gsub(/[^0-9]/, '')

      if work_phone_value[0] == '1' || work_phone_value[0] == '0' || work_phone_value.size != 10
        self.work_phone = nil
      else
        self.work_phone = work_phone_value
      end
    end
  end

  def self.valid_email(email_address)
    unless email_address.match(/\A[^@]+@([^@\.]+\.)+[^@\.]+\z/).nil?
      return true
    else
      return false
    end
  end

  def cleanup_emails
    if self.email_address_1.nil? || Customer.valid_email(self.email_address_1) == false
      self.email_address_1 = nil
    else
      if self.email_address_1.downcase.present? && self.email_address_1.downcase.size > 0
        self.email_address_1 = self.email_address_1.downcase
      end
    end

    if self.email_address_2.nil? || Customer.valid_email(self.email_address_2) == false
      self.email_address_2 = nil
    else
      if self.email_address_2.downcase.present? && self.email_address_2.downcase.size > 0
        self.email_address_2 = self.email_address_2.downcase
      end
    end
  end

  def check_valid_number(phone_number)
    return false if phone_number.blank?

    return false if !phone_number.gsub(/[^0-9]/, '')

  end

  def set_full_name
    self.full_name = self.get_full_name
  end

  def check_valid_phones
    if self.home_phone.present? && self.check_valid_number(self.home_phone) && !self.home_phone_dnc_flag
      self.home_phone = self.home_phone
    else
      self.home_phone = nil
    end

    if self.work_phone.present? && self.check_valid_number(self.work_phone) && !self.work_phone_dnc_flag
      self.work_phone = self.work_phone
    else
      self.work_phone = nil
    end

    if self.cell_phone.present? && self.check_valid_number(self.cell_phone) && !self.cell_phone_dnc_flag
      self.cell_phone = self.cell_phone
    else
      self.cell_phone = nil
    end
  end

  def get_full_name
    "#{self.first_name} #{self.last_name}"
  end

  def campaign_customers
    CampaignCustomer.where(customer_id: self.id).order("created_at DESC")
  end

  def create_postal_code
    unless self.postal_code.blank?
      PostalCode.where(dealer_id: self.dealer_id, value: self.postal_code).first_or_create
    end
  end

  def send_call_recording(call, email_address)
    SendgridMailer.send_call_recording(call, email_address).deliver
  end

end