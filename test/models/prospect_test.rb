# == Schema Information
#
# Table name: prospects
#
#  id                 :integer          not null, primary key
#  event_id           :integer
#  customer_id        :integer
#  dealer_id          :integer
#  prospect_type_id   :integer
#  prospect_timestamp :datetime         default(2013-12-10 03:31:46 UTC)
#  prospect_status_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#  user_id            :integer
#  campaign_id        :integer
#

require 'test_helper'

class ProspectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
