# == Schema Information
#
# Table name: job_titles
#
#  id             :integer          not null, primary key
#  job_title_name :string(255)
#  is_active      :boolean
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class JobTitleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
