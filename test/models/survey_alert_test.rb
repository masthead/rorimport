# == Schema Information
#
# Table name: survey_alerts
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  alert_type           :string(255)
#  alert_text           :text
#  alert_json           :text
#  dealer_id            :integer
#  created_at           :datetime
#  updated_at           :datetime
#  customer_id          :integer
#  employee_string      :string(255)
#  campaign_customer_id :integer
#  campaign_id          :integer
#

require 'test_helper'

class SurveyAlertTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
