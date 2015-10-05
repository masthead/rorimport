# == Schema Information
#
# Table name: asr_pro_data
#
#  id               :integer          not null, primary key
#  service_id       :integer
#  pdf_url          :string(255)
#  invoke_url       :string(255)
#  dealer_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#  service_ronumber :string(255)
#  asr_dealer_key   :integer
#  asr_csv_id       :integer
#

require 'test_helper'

class AsrProDataTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
