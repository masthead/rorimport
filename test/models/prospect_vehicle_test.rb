# == Schema Information
#
# Table name: prospect_vehicles
#
#  id            :integer          not null, primary key
#  prospect_id   :integer
#  vehicle_year  :string(255)
#  vehicle_make  :string(255)
#  vehicle_model :string(255)
#  vin           :string(255)
#  stock_number  :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  vehicle_type  :string(255)
#

require 'test_helper'

class ProspectVehicleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
