# == Schema Information
#
# Table name: agents
#
#  id              :integer          not null, primary key
#  agent_status_id :integer
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  duration        :integer
#  end_time        :datetime
#  call_queue_id   :integer
#

require 'test_helper'

class AgentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
