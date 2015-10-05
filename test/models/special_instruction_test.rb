# == Schema Information
#
# Table name: special_instructions
#
#  id                          :integer          not null, primary key
#  special_instruction_type_id :integer
#  instruction_text            :text
#  dealer_id                   :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#

require 'test_helper'

class SpecialInstructionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
