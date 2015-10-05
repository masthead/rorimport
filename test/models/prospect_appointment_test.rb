# == Schema Information
#
# Table name: prospect_appointments
#
#  id                   :integer          not null, primary key
#  prospect_id          :integer
#  appointment_datetime :datetime
#  is_shown             :boolean
#  created_at           :datetime
#  updated_at           :datetime
#  user_id              :integer
#  appointment_time     :time
#

require 'test_helper'

class ProspectAppointmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
