# == Schema Information
#
# Table name: asr_csvs
#
#  id         :integer          not null, primary key
#  file_name  :string(255)
#  s3_url     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class AsrCsvTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
