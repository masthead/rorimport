# == Schema Information
#
# Table name: dispositions
#
#  id                      :integer          not null, primary key
#  disposition_description :string(255)
#  is_active               :boolean          default(FALSE)
#  created_at              :datetime
#  updated_at              :datetime
#  is_complete             :boolean          default(FALSE)
#  is_system               :boolean          default(FALSE)
#  denotes_appointment     :boolean          default(FALSE)
#  is_default              :boolean          default(FALSE)
#  denotes_contact         :boolean          default(FALSE)
#  denotes_callback        :boolean          default(FALSE)
#  send_survey             :boolean          default(FALSE)
#

require 'test_helper'

class DispositionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
