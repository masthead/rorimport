# == Schema Information
#
# Table name: setup_tasks
#
#  id               :integer          not null, primary key
#  priority         :integer
#  task_description :text
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class SetupTaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
