# == Schema Information
#
# Table name: departments
#
#  id                 :integer          not null, primary key
#  dealer_id          :integer
#  department_name    :string(255)
#  phone_number       :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  hours_of_operation :text
#

require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
