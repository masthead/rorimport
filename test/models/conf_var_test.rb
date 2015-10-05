# == Schema Information
#
# Table name: conf_vars
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ConfVarTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
