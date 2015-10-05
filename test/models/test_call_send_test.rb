# == Schema Information
#
# Table name: test_call_sends
#
#  id              :integer          not null, primary key
#  email_addresses :text
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  send_url        :string(255)
#  token           :string(255)
#  test_call_array :text
#

require 'test_helper'

class TestCallSendTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
