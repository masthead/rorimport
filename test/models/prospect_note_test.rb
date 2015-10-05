# == Schema Information
#
# Table name: prospect_notes
#
#  id          :integer          not null, primary key
#  prospect_id :integer
#  notes       :text
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#

require 'test_helper'

class ProspectNoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
