# == Schema Information
#
# Table name: survey_attempts
#
#  id                   :integer          not null, primary key
#  call_record_id       :integer
#  created_at           :datetime
#  updated_at           :datetime
#  customer_id          :integer
#  campaign_id          :integer
#  user_id              :integer
#  disposition_id       :integer
#  employee_id          :integer
#  department_id        :integer
#  from_number          :string(255)
#  to_number            :string(255)
#  campaign_customer_id :integer
#  is_deleted           :boolean          default(FALSE)
#

require 'test_helper'

class SurveyAttemptTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
