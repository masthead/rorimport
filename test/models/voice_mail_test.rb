# == Schema Information
#
# Table name: voice_mails
#
#  id                :integer          not null, primary key
#  campaign_id       :integer
#  attempt_number    :integer
#  voicemail_message :text
#  created_at        :datetime
#  updated_at        :datetime
#

require 'test_helper'

class VoiceMailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
