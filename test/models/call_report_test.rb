# == Schema Information
#
# Table name: call_reports
#
#  id                 :integer          not null, primary key
#  appointment_id     :integer
#  customer_id        :integer
#  call_record_id     :integer
#  dealer_id          :integer
#  service_id         :integer
#  contacted_at       :datetime
#  contact_type       :string(255)
#  service_date       :datetime
#  call_status        :string(255)
#  appointment_source :string(255)
#

require 'test_helper'

class CallReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
