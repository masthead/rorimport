# == Schema Information
#
# Table name: vehicles
#
#  id         :integer          not null, primary key
#  vin        :string(255)
#  vyear      :string(255)
#  vmake      :string(255)
#  vmodel     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class VehicleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
