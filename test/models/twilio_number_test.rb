# == Schema Information
#
# Table name: twilio_numbers
#
#  id           :integer          not null, primary key
#  phone_number :string(255)
#  is_active    :boolean
#  created_at   :datetime
#  updated_at   :datetime
#  redirect_to  :string(255)
#

require 'test_helper'

class TwilioNumberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
