# == Schema Information
#
# Table name: call_types
#
#  id            :integer          not null, primary key
#  type_name     :string(255)
#  default_price :float
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class CallTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
