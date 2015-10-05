# == Schema Information
#
# Table name: contents
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  key        :string(255)
#  value      :text
#

require 'test_helper'

class ContentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
