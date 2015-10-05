# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  value      :text
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
