class LaborType < ActiveRecord::Base

  validates :dealer_id, :uniqueness => { :scope => :name }, :allow_nil => false, :allow_blank => false

  has_many :labor_type_services
  has_many :services, :through => :labor_type_services

  has_many :criterion_labor_types
  has_many :criterions, :through => :criterion_labor_types
end
