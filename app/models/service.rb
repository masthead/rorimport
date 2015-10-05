class Service < ActiveRecord::Base

  paginates_per 25

  belongs_to :dealer
  belongs_to :customer
  belongs_to :customer_vehicle
  has_one :vehicle, through: :customer_vehicle
  belongs_to :s3file
  has_many :campaign_run_customers

  has_many :campaign_customers
  has_one :event, as: :eventable

  has_many :labor_type_services
  has_many :labor_types, :through => :labor_type_services

  has_many :operation_code_services
  has_many :operation_codes, :through => :operation_code_services

  has_one :asr_pro_data
  has_many :asr_declines, :through => :asr_pro_data

  after_save :update_or_create_event
  before_save :update_or_create_customer_vehicle

  before_save :get_rolines

  validates_presence_of :dealer_id, :ronumber

  def update_or_create_event

    if self.event_id.present? && self.event_id > 0
      e = Event.where(id: self.event_id).first

      if e.present? && e.id > 0
        self.event = e
      else
        e = self.create_event
      end

    else
      if self.event.present?
        e = self.event
      else
        e = self.create_event
      end
    end

    #   need to update the event with some details on the sale transaction
    e.event_timestamp = self.closeddate
    e.transaction_amount = self.roamount
    e.dealer_id = self.dealer_id
    e.customer_id = self.customer_id
    e.customer_vehicle_id = self.customer_vehicle_id

    e.save!

  end

  def update_or_create_customer_vehicle
    vehicle = Vehicle.where(vin: self.vehiclevin).first_or_create
    customer_vehicle = CustomerVehicle.where(
        customer_id: self.customer_id,
        vehicle_id: vehicle.id
    ).first_or_create

    self.customer_vehicle_id = customer_vehicle.id

    if customer_vehicle.present? && customer_vehicle.is_a?(CustomerVehicle)
      customer_vehicle.set_calculated_fields
      customer_vehicle.save!
    end
  end

  def display_vehicle
    if self.customer_vehicle_id.present? && self.customer_vehicle_id > 0
      vehicle = "#{self.vehicle.vyear} #{self.vehicle.vmake} #{self.vehicle.vmodel}"
    else
      vehicle = "Unknown"
    end

    vehicle
  end

  def get_rolines

    unless self.operationcode.blank?
      # op codes are pipe delimited
      operation_codes = self.operationcode.split("|")

      # opcode descriptions are pipe delimited
      operation_descriptions = self.operationdescription.split("|")

      # count the lines to figure out how big to make the array
      lines = operation_codes.count

      # build a multi-dimensional array of n size
      rolines = Array.new

      n = 0
      until n == lines
        rolines << { :operation_code => operation_codes[n], :operation_description => operation_descriptions[n] }
        n = n + 1
      end

      if rolines.present? && rolines.count > 0
        rolines.each do |ro_line|

          # find or create a new dealer operation code
          op_code = self.dealer.operation_codes.where(name: ro_line[:operation_code], description: ro_line[:operation_description]).first_or_create

          # associate the operation code with this service record
          OperationCodeService.where(service_id: self.id, operation_code_id: op_code.id).first_or_create
        end
      end
    end

    unless self.labortypes.blank?
      # now get each labor type
      labor_types = self.labortypes.split("|")

      if labor_types.present? && labor_types.size > 0
        labor_types.each do |labor_type|

          # find or create the dealer labor type
          labor = self.dealer.labor_types.where(name: labor_type).first_or_create

          # associate the new labor type with this service
          LaborTypeService.where(service_id: self.id, labor_type_id: labor.id).first_or_create
        end
      end
    end

  rescue => e
    puts "Could not create ro lines"

    Raven.capture_exception(e) if Rails.env.production?
  end
end