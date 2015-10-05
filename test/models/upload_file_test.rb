# == Schema Information
#
# Table name: upload_files
#
#  id                     :integer          not null, primary key
#  user_id                :integer
#  created_at             :datetime
#  updated_at             :datetime
#  campaign_id            :integer
#  file_name              :string(255)
#  file_name_file_name    :string(255)
#  file_name_content_type :string(255)
#  file_name_file_size    :integer
#  file_name_updated_at   :datetime
#  csv_file_name          :string(255)
#  csv_content_type       :string(255)
#  csv_file_size          :integer
#  csv_updated_at         :datetime
#  friendly_name          :string(255)
#

require 'test_helper'

class UploadFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
