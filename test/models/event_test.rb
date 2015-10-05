# == Schema Information
#
# Table name: events
#
#  id                  :integer          not null, primary key
#  event_type_id       :integer
#  event_timestamp     :datetime
#  customer_id         :integer
#  dealer_id           :integer
#  transaction_amount  :decimal(, )
#  vehicle_id          :integer
#  created_at          :datetime
#  updated_at          :datetime
#  customer_vehicle_id :integer
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
