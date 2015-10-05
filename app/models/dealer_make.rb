class DealerMake < ActiveRecord::Base
  belongs_to :dealer
  belongs_to :vehicle_make
end
