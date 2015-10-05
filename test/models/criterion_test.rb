# == Schema Information
#
# Table name: criterions
#
#  id          :integer          not null, primary key
#  campaign_id :integer
#  query       :string(255)
#  params      :text
#  total       :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class CriterionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
