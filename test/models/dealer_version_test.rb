# == Schema Information
#
# Table name: dealer_versions
#
#  id         :integer          not null, primary key
#  item_type  :string(255)      not null
#  item_id    :integer          not null
#  event      :string(255)      not null
#  whodunnit  :string(255)
#  object     :text
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class DealerVersionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end