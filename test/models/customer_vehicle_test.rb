# == Schema Information
#
# Table name: customers_vehicles
#
#  id                   :integer          not null, primary key
#  customer_id          :integer
#  vehicle_id           :integer
#  created_at           :datetime
#  updated_at           :datetime
#  last_mileage         :integer
#  estimated_mileage    :integer
#  last_mileage_date    :datetime
#  mileage_estimated_at :datetime
#

require 'test_helper'

class CustomerVehicleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
