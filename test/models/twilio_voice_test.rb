# == Schema Information
#
# Table name: twilio_voices
#
#  id               :integer          not null, primary key
#  incoming_params  :text
#  twilio_number_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class TwilioVoiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
