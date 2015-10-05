class Sale < ActiveRecord::Base

  belongs_to :dealer
  belongs_to :customer
  belongs_to :customer_vehicle
  has_one :vehicle, through: :customer_vehicle
  belongs_to :s3file
  has_many :campaign_run_customers

  has_many :campaign_customers
  has_one :event, as: :eventable

  after_save :update_or_create_event
  before_save :update_or_create_customer_vehicle

  after_create :update_or_create_sales_data

  validates_presence_of :dealer_id, :dealnumber

  # Campaign Builder Scopes
  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

  #TODO - all of these are stubs
  # scope :with_lease_expiration, -> (params) { }
  # scope :with_purchase_type, -> (params) { }
  # scope :with_finance_type, -> (params) { }
  # scope :with_payment_range, -> (params) { }

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

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
    e.event_timestamp = self.dealbookdate
    e.transaction_amount = self.cashprice
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

  def update_or_create_sales_data
    sale_data = SaleDatum.where(customer_vehicle_id: self.customer_vehicle_id).first_or_create

    sale_data.get_sales_data
  end

  def get_vehicle_type
    if self.vehicletype.present?
      if self.vehicletype.match(/U/i)
        type = :used_vehicle
      elsif self.vehicletype.match(/N/i)
        type = :new_vehicle
      else
        type = nil
      end
    else
      type = nil
    end

    type
  end

  def get_bank
    if self.bankname.present? && self.bankname.match(/^[a-z]/i) && !self.bankname.match(/cash/i)
      provider = Provider.where(dealer_id: self.dealer_id, type: "Bank", name: self.bankname.titleize).first_or_create
    else
      provider = nil
    end

    provider
  end

  def get_purchase_type

    lease = ['L', 'l', 'Lease', 'lease']
    purchase = ['P', 'p', 'Retail']

    if self.bankname.present? && self.bankname.match(/cash/i)
      type = :cash_purchase
    elsif self.dealtype.present? && lease.include?(self.dealtype)
      type = :lease_purchase
    elsif self.dealtype.present? && purchase.include?(self.dealtype)
      type = :finance_purchase
    else
      type = nil
    end

    type
  end

  def get_extended_warranty
    if self.extendedwarrantyname.present?
      provider = Provider.where(dealer_id: self.dealer_id, type: "Warranty", name: self.extendedwarrantyname.titleize).first_or_create
    else
      provider = nil
    end

    provider
  end

  def get_lease_expiration
    if self.get_purchase_type == :lease_purchase

      if self.vehiclemileage.to_i > 0 && self.leaseannualmiles.to_i > 0 && (self.leaseterm.to_i > 0 || self.term.to_i > 0)

        lease_term_years = self.leaseterm.to_i > 0 ? (self.leaseterm.to_i / 12) : (self.term.to_i / 12)

        total_allowed_mileage = self.leaseannualmiles.to_i * lease_term_years

        lease_expiration = {
            expiration_miles: self.vehiclemileage.to_i + total_allowed_mileage,
            expiration_months: self.dealbookdate + lease_term_years.years
        }
      end
    else
      lease_expiration = nil
    end

    lease_expiration
  end

  def get_warranty_expiration

    if self.vehiclemileage.to_i > 0 && self.extendedwarrantyterm.to_i > 0 && self.extendedwarrantylimitmiles.to_i > 0

      warranty_term_years = self.extendedwarrantyterm.to_i / 12

      warranty_expiration = {
          expiration_miles: self.vehiclemileage.to_i + self.extendedwarrantylimitmiles.to_i,
          expiration_months: self.dealbookdate + warranty_term_years.years
      }
    else
      warranty_expiration = nil
    end

    warranty_expiration
  end

  def get_finance_information

  end

  def trades
    trades = []

    trades << self.tradein_1_vin if self.tradein_1_vin.present?
    trades << self.tradein_2_vin if self.tradein_2_vin.present?

    trades
  end
end
