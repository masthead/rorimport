# == Schema Information
#
# Table name: survey_template_questions
#
#  id                               :integer          not null, primary key
#  question_order                   :integer
#  question_text                    :text
#  survey_template_question_type_id :integer
#  created_at                       :datetime
#  updated_at                       :datetime
#  survey_template_id               :integer
#  has_options                      :boolean
#  is_required                      :boolean          default(FALSE)
#  report_question_text             :text
#  is_active                        :boolean
#

require 'test_helper'

class SurveyTemplateQuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
