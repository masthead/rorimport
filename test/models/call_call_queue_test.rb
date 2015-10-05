# == Schema Information
#
# Table name: call_call_queues
#
#  id            :integer          not null, primary key
#  call_id       :integer
#  call_queue_id :integer
#  agent_id      :integer
#  created_at    :datetime
#  updated_at    :datetime
#  priority      :integer          default(50)
#  is_waiting    :boolean          default(TRUE)
#  is_complete   :boolean          default(FALSE)
#

require 'test_helper'

class CallCallQueueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
