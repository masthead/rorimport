# == Schema Information
#
# Table name: languages
#
#  id            :integer          not null, primary key
#  language_name :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  priority      :integer
#

require 'test_helper'

class LanguageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
