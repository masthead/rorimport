# == Schema Information
#
# Table name: promotions
#
#  id              :integer          not null, primary key
#  dealer_id       :integer
#  start_date      :datetime
#  end_date        :datetime
#  promotion_title :string(255)
#  promotion_text  :text
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class PromotionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
