class Vehicle < ActiveRecord::Base

  has_many :extended_datum, as: :extended
  has_many :events
  has_many :campaign_customers
  has_many :services
  has_many :sales
  has_many :appointments
  has_many :customers_vehicles, class_name: 'CustomerVehicle'
  has_many :customers, through: :customers_vehicles
  belongs_to :vehicle_year
  belongs_to :vehicle_make
  belongs_to :vehicle_model

  validates_uniqueness_of :vin, allow_nil: false, allow_blank: false

  # after_commit :validate_vin, on: [:create]

  # convenience methods
  def vyear
    if self.vehicle_year.present?
      self.vehicle_year.name
    else
      "Unknown Year"
    end
  end

  def vmake
    if self.vehicle_make.present?
      self.vehicle_make.name
    else
      "Unknown Make"
    end
  end

  def vmodel
    if self.vehicle_model.present?
      self.vehicle_model.name
    else
      "Unknown Model"
    end
  end

  def has_valid_vin?
    self.vin.present? && self.vin.match(/^[A-Za-z0-9]{17}+$/)
  end

  def get_squishvin
    if self.vin.length == 17
      sv = (vin[0..7] + vin[9..10])
    else
      sv = ''
    end

    sv
  end

  def set_valid_vin
    self.update(valid_vin: true, squish_vin: self.get_squishvin)

    # get_autodata
  end

  def validate_vin
    if self.has_valid_vin?

      self.set_valid_vin
    end
  end

  def get_autodata

    if self.valid_vin?
      if self.squish_vin.blank?
        self.squish_vin = self.get_squishvin

        self.save!
      end

      veh = Vehicle.find(self.id)

      a = AutoData.where(
          squish_vin: veh.squish_vin
      ).first

      if a && a.present? && a.id > 0
        vehicle_year = VehicleYear.where(
            name: a.year
        ).first_or_create

        vehicle_make = VehicleMake.where(
            name: a.make
        ).first_or_create

        vehicle_model = VehicleModel.where(
            name: a.model
        ).first_or_create

        veh.extended_datum.where(
            key: "style",
            value: a.style
        ).first_or_create

        veh.extended_datum.where(
            key: "trim",
            value: a.trim
        ).first_or_create

        veh.extended_datum.where(
            key: "body_type",
            value: a.body_type
        ).first_or_create

        veh.vehicle_year_id = vehicle_year.id
        veh.vehicle_make_id = vehicle_make.id
        veh.vehicle_model_id = vehicle_model.id


        veh.save!
      else
        veh.get_edmunds
      end
    end

  end

  def get_edmunds

    if self.valid_vin?

      config = YAML.load_file(Rails.root+"config/application.yml")[Rails.env]

      vehicle_url = "https://api.edmunds.com/api/vehicle/v2/vins/#{self.vin}?fmt=json&api_key=#{config["EDMUNDS_KEY"]}"

      response = Typhoeus.get(vehicle_url, followlocation:true)

      if response && response.code == 200

        response_body = JSON.parse(response.body)

        if response_body["years"].present? && response_body["make"].present? && response_body["model"].present?

          vehicle_year = VehicleYear.where(name: response_body["years"].first["year"]).first_or_create
          vehicle_make = VehicleMake.where(name: response_body["make"]["name"]).first_or_create
          vehicle_model = VehicleModel.where(name: response_body["model"]["name"]).first_or_create

          self.vehicle_year_id = vehicle_year.id
          self.vehicle_make_id = vehicle_make.id
          self.vehicle_model_id = vehicle_model.id
          self.validate_processed = true

          self.extended_datum.where(key: "vehicle_type", value: response_body["categories"]["vehicleType"]).first_or_create

        end
      else
        self.validate_processed = true
      end

      self.save!

    end
  end
end
