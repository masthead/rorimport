# == Schema Information
#
# Table name: campaign_survey_alerts
#
#  id          :integer          not null, primary key
#  campaign_id :integer
#  employee_id :integer
#  send_email  :boolean
#  send_text   :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  is_active   :boolean
#

require 'test_helper'

class CampaignSurveyAlertTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
