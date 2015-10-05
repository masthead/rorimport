# == Schema Information
#
# Table name: call_steps
#
#  id             :integer          not null, primary key
#  call_id        :integer
#  call_status_id :integer
#  agent_id       :integer
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class CallStepTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
