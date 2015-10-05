# == Schema Information
#
# Table name: agent_statuses
#
#  id          :integer          not null, primary key
#  status_name :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  is_online   :boolean          default(FALSE)
#

require 'test_helper'

class AgentStatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
