class DealerYear < ActiveRecord::Base
  belongs_to :dealer
  belongs_to :vehicle_year
end
