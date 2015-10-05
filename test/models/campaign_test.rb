# == Schema Information
#
# Table name: campaigns
#
#  id                       :integer          not null, primary key
#  campaign_name            :string(255)
#  dealer_id                :integer
#  start_date               :datetime
#  end_date                 :datetime
#  survey_template_id       :integer
#  user_id                  :integer
#  created_at               :datetime
#  updated_at               :datetime
#  is_active                :boolean
#  campaign_type_id         :integer
#  max_attempts             :integer
#  customer_expiration_days :integer
#  voicemail_message        :text
#  status                   :string(255)
#  twilio_number_id         :integer
#  total_count              :integer          default(0)
#  recurring_type           :integer          default(0)
#  recurring_days           :text
#  priority                 :integer          default(0)
#  marketing_exclusion_days :integer          default(30)
#  campaign_group_id        :integer
#  include_roi              :boolean          default(FALSE)
#  dealer_call_type_id      :integer
#  exclusion_exempt         :boolean          default(FALSE)
#  communication_type_id    :integer
#

require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
