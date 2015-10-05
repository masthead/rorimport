class VehicleMake < ActiveRecord::Base
  has_many :vehicles
  has_many :dealers

  has_many :criterion_vehicle_makes
  has_many :criterions, :through => :criterion_vehicle_makes
end
