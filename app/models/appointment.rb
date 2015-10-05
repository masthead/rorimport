class Appointment < ActiveRecord::Base

  belongs_to :dealer
  belongs_to :customer
  belongs_to :customer_vehicle
  has_one :vehicle, through: :customer_vehicle
  belongs_to :s3file
  has_many :campaign_run_customers

  has_many :campaign_customers
  has_one :event, as: :eventable

  has_one :survey

  after_save :update_or_create_event
  before_save :update_or_create_customer_vehicle

  validates_uniqueness_of :appointment_datetime, :scope => [ :dealer_id, :customer_id, :vin, :first_name, :last_name ]
  validates_presence_of :dealer_id

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

    #   need to update the event with some details on the appointment
    e.event_timestamp = self.appointment_datetime
    e.dealer_id = self.dealer_id
    e.customer_id = self.customer_id
    e.customer_vehicle_id = self.customer_vehicle_id

    e.save!

  end

  def update_or_create_customer_vehicle
    if self.vin.present? && self.vin.size > 0
      vehicle = Vehicle.where(vin: self.vin).first_or_create
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
  end

  def send_appointment_notification
    if self.dealer.send_appointment_alerts == true && self.sent_notification == false && self.sub_category == '3' && self.appointment_datetime.present? && self.appointment_datetime > Time.now - 1.day

      if self.dealer.contacts.present?

        dealer_contacts = self.dealer.contacts.split(',')

        dealer_contacts.each do |contact|
          # Notifier.send_appointment(self, contact).deliver
          SendgridMailer.send_appointment(self, contact).deliver
        end

        self.update(sent_notification: true)
      end
    end
  end
end
