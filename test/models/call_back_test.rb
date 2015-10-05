# == Schema Information
#
# Table name: call_backs
#
#  id                   :integer          not null, primary key
#  campaign_customer_id :integer
#  callback_at          :datetime
#  notes                :text
#  user_id              :integer
#  completed_at         :datetime
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class CallBackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
