# == Schema Information
#
# Table name: campaign_runs
#
#  id                      :integer          not null, primary key
#  created_at              :datetime
#  updated_at              :datetime
#  eligible_customer_count :integer
#  enrolled_customer_count :integer
#  campaign_id             :integer
#  schedule_date           :datetime
#  status                  :string(255)
#  campaign_queries        :text             default("")
#

require 'test_helper'

class CampaignRunTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
