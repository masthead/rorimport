# == Schema Information
#
# Table name: dealer_call_types
#
#  id           :integer          not null, primary key
#  dealer_id    :integer
#  call_type_id :integer
#  price        :float
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class DealerCallTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
