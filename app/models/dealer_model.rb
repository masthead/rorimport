class DealerModel < ActiveRecord::Base
  belongs_to :dealer
  belongs_to :vehicle_model
end
