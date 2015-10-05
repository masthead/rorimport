# == Schema Information
#
# Table name: s3files
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  size       :integer
#  file_type  :string(255)
#  total_rows :integer          default(0)
#  new_rows   :integer          default(0)
#

require 'test_helper'

class S3fileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
