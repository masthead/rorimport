class Event < ActiveRecord::Base

  belongs_to :customer
  belongs_to :dealer
  belongs_to :customer
  belongs_to :customer_vehicle
  belongs_to :eventable, polymorphic: true

  validates_presence_of :customer_id, :dealer_id, :eventable_id, :eventable_type

  def transaction
    self.eventable
  end

  def transaction_mileage
    case self.eventable_type
      when "Sale"
      then self.eventable.vehiclemileage
      when "Service"
      then self.eventable.vehiclemileage
      else
        ""
    end
  end

  def transaction_date
    case self.eventable_type
      when "Sale"
      then self.eventable.dealbookdate
      when "Service"
      then self.eventable.closeddate
      else
        ""
    end
  end

  def transaction_number
    case self.eventable_type
      when "Sale"
        then self.eventable.dealnumber
      when "Service"
        then self.eventable.ronumber
      when "Appointment"
        then self.eventable.dms_appointment_number
      else
        ""
    end
  end

  def prepare_data

    puts "horse"
    puts self.inspect

    result = {
            :event_id           => self.id,
            :transaction_id     => self.try(:transaction).try(:id),
            :type               => self.eventable_type,
            :timestamp          => self.event_timestamp,
            :transaction_number => self.try(:transaction_number)
        }

    result

  end

end
