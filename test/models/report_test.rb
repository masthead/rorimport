# == Schema Information
#
# Table name: reports
#
#  id                 :integer          not null, primary key
#  report_url         :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  email_addresses    :text
#  token              :string(255)
#  dealer_id          :integer
#  campaign_id        :integer
#  campaign_group_id  :integer
#  push_invoice       :boolean          default(FALSE)
#  params             :text
#  schedule_frequency :string(255)
#

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
