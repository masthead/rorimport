class CustomerVehicle < ActiveRecord::Base

  self.table_name = :customers_vehicles

  has_many :events
  belongs_to :customer
  belongs_to :vehicle
  has_one :sale
  has_many :services
  has_many :appointments
  has_one :sale_datum
  has_many :customers_vehicles
  has_many :campaign_customers

  after_commit :set_dealer_vehicles, on: [:update, :create], if: :valid_customer?

  validates :customer_id, :uniqueness => { :scope => [:vehicle_id] }, :allow_nil => false, :allow_blank => false

  validates_presence_of :customer_id, :vehicle_id

  def display_vehicle
    if self.vehicle.has_valid_vin?
      "#{self.vehicle.vyear} #{self.vehicle.vmake} #{self.vehicle.vmodel}"
    else
      "Unknown Year Make Model"
    end
  end

  def valid_customer?
    customer_id.present? && customer.is_a?(Customer) && customer.dealer_id.present?
  end

  def set_dealer_vehicles

    DealerYear.where(
        dealer_id: customer.dealer_id,
        vehicle_year_id: vehicle.vehicle_year_id
    ).first_or_create

    DealerMake.where(
        dealer_id: customer.dealer_id,
        vehicle_make_id: vehicle.vehicle_make_id
    ).first_or_create

    DealerModel.where(
        dealer_id: customer.dealer_id,
        vehicle_model_id: vehicle.vehicle_model_id
    ).first_or_create
  end

  def services_list
    self.events.where(eventable_type: "Service").order("event_timestamp ASC")
  end

  def last_service
      self.services_list.last
  end

  def set_calculated_fields

    if self.last_service
      self.service_visits = self.services_list.count
      self.last_service_date = self.last_service.event_timestamp
      self.last_service_id = self.last_service.transaction.id
      self.last_service_event_id = self.last_service.id
    end

    if self.last_sale
      self.sale_date = self.last_sale.event_timestamp
      self.last_sale_event_id = self.last_sale.id
      self.last_sale_id = self.last_sale.transaction.id
    end

    if self.last_sale_or_service_event
      self.last_mileage = self.last_sale_or_service_event.transaction_mileage
      self.last_mileage_date = self.last_sale_or_service_event.event_timestamp
    end
  end

  def last_sale
    self.events.where(eventable_type: "Sale").order("event_timestamp ASC").last
  end

  def last_sale_or_service_event
    self.events.where("eventable_type = ? OR eventable_type = ?", "Sale", "Service").order("event_timestamp ASC").last
  end

  def estimate_mileage

    last_sale_or_service = self.last_sale_or_service_event

    if last_sale_or_service && last_sale_or_service.transaction_date.present? && last_sale_or_service.transaction_mileage.present?

      event_time = last_sale_or_service.event_timestamp.present? ? last_sale_or_service.event_timestamp : last_sale_or_service.transaction_date

      if last_sale_or_service && event_time > Date.today - 1000.years
        days_since_last_visit     = (Time.now - event_time)/1.day
        miles_since_last_visit    = days_since_last_visit * Setting.average_daily_mileage
        last_mileage = last_sale_or_service.transaction_mileage

        # set the fields according to the last transaction and mileage estimator
        self.estimated_mileage    = last_mileage.to_f + miles_since_last_visit.to_f
        self.mileage_estimated_at = Time.now
      end
    end
  end

  def previous_service_date
    services = Service.where(customer_vehicle_id: self.id).order('closeddate DESC')

    if services.present? && services.count > 1 && services[1].present?
      previous_visit = services[1].closeddate
    else
      previous_visit = nil
    end

    previous_visit

  end

  def self.prepare_data(campaign_customer_id, vehicle_only = true)

    campaign_customer = CampaignCustomer.find(campaign_customer_id)

    if vehicle_only && campaign_customer.vehicle_id.present? && campaign_customer.vehicle_id > 0

      customer_vehicle = CustomerVehicle.where(customer_id: campaign_customer.customer_id, vehicle_id: campaign_customer.vehicle_id).first

      service_history = Service.where(customer_vehicle_id: customer_vehicle.id).limit(10)
    else

      service_history = Service.where(customer_id: campaign_customer.customer_id).order("closeddate DESC").limit(10)
    end

    if service_history.present? && service_history.count > 0
      service_history.map { |service| {
          :service_id  => service.id,
          :ro_number   => service.ronumber,
          :closed_date => service.closeddate,
          :vehicle     => service.display_vehicle,
          :ro_amount   => service.roamount
      }
      }
      # fix
      # :vin         => service.vehicle.vin,
    else
      return []
    end
  end

end
