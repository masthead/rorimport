class LaborTypeService < ActiveRecord::Base

  belongs_to :labor_type
  belongs_to :service
end