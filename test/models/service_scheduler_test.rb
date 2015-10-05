# == Schema Information
#
# Table name: service_schedulers
#
#  id             :integer          not null, primary key
#  scheduler_name :string(255)
#  login_url      :text
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class ServiceSchedulerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
