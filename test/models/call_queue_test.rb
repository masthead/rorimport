# == Schema Information
#
# Table name: call_queues
#
#  id                           :integer          not null, primary key
#  call_queue_name              :string(255)
#  twilio_number_id             :integer
#  dealer_id                    :integer
#  created_at                   :datetime
#  updated_at                   :datetime
#  hold_music_file_name         :string(255)
#  hold_music_content_type      :string(255)
#  hold_music_file_size         :integer
#  hold_music_updated_at        :datetime
#  hold_message                 :text
#  greeting_mp3_file_name       :string(255)
#  greeting_mp3_content_type    :string(255)
#  greeting_mp3_file_size       :integer
#  greeting_mp3_updated_at      :datetime
#  transfer_mp3_file_name       :string(255)
#  transfer_mp3_content_type    :string(255)
#  transfer_mp3_file_size       :integer
#  transfer_mp3_updated_at      :datetime
#  after_hours_mp3_file_name    :string(255)
#  after_hours_mp3_content_type :string(255)
#  after_hours_mp3_file_size    :integer
#  after_hours_mp3_updated_at   :datetime
#  after_hours_message          :text
#  greeting_message             :text
#  transfer_message             :text
#  language_id                  :integer
#  queue_sid                    :string(255)
#

require 'test_helper'

class CallQueueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
