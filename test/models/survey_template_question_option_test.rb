# == Schema Information
#
# Table name: survey_template_question_options
#
#  id                          :integer          not null, primary key
#  survey_template_question_id :integer
#  question_option             :string(255)
#  question_option_order       :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#  send_survey                 :boolean
#  is_active                   :boolean
#

require 'test_helper'

class SurveyTemplateQuestionOptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
