# == Schema Information
#
# Table name: asr_declines
#
#  id                      :integer          not null, primary key
#  asr_pro_data_id         :integer
#  recommendation          :text
#  recommendation_priority :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  price                   :float            default(0.0)
#

require 'test_helper'

class AsrDeclineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
