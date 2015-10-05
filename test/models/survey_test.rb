# == Schema Information
#
# Table name: surveys
#
#  id                   :integer          not null, primary key
#  campaign_id          :integer
#  customer_id          :integer
#  survey_template_id   :integer
#  created_at           :datetime
#  updated_at           :datetime
#  user_id              :integer
#  survey_attempt_id    :integer
#  appointment_datetime :datetime
#  appointment_time     :time
#  appointment_id       :integer
#  appointment_date     :date
#  survey_disposition   :text
#  campaign_customer_id :integer
#  has_answers          :boolean
#

require 'test_helper'

class SurveyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
