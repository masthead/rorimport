# == Schema Information
#
# Table name: call_queues_users
#
#  id            :integer          not null, primary key
#  call_queue_id :integer
#  user_id       :integer
#  logged_in     :boolean          default(FALSE)
#

require 'test_helper'

class CallQueueUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
