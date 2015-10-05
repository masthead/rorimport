# == Schema Information
#
# Table name: survey_answers
#
#  id                          :integer          not null, primary key
#  survey_template_question_id :integer
#  survey_answer               :text
#  created_at                  :datetime
#  updated_at                  :datetime
#  survey_id                   :integer
#

require 'test_helper'

class SurveyAnswerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
