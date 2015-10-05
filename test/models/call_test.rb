# == Schema Information
#
# Table name: calls
#
#  id                   :integer          not null, primary key
#  call_sid             :string(255)
#  called               :string(255)
#  direction            :string(255)
#  to_number            :string(255)
#  from_number          :string(255)
#  caller               :string(255)
#  duration             :integer
#  twilio_recording_url :string(255)
#  start_time           :datetime
#  end_time             :datetime
#  uri                  :string(255)
#  phone_number_sid     :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  call_status_id       :integer
#  parent_call_sid      :string(255)
#  customer_id          :integer
#  campaign_id          :integer
#  campaign_customer_id :integer
#  survey_attempt_id    :integer
#  call_record          :boolean          default(TRUE)
#  is_complete          :boolean          default(FALSE)
#  recording_url        :string(255)
#

require 'test_helper'

class CallTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
