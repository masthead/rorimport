# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  category_name :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  is_default    :boolean          default(FALSE)
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
