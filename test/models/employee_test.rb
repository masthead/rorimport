# == Schema Information
#
# Table name: employees
#
#  id                        :integer          not null, primary key
#  is_active                 :boolean
#  user_id                   :integer
#  dealer_id                 :integer
#  job_title_id              :integer
#  created_at                :datetime
#  updated_at                :datetime
#  accepts_transferred_calls :boolean
#  direct_inward_dial        :string(255)
#  phone_extension           :string(255)
#  department_id             :integer
#  contact_notifications     :boolean
#  dms_key                   :string(255)
#

require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
