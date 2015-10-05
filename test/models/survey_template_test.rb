# == Schema Information
#
# Table name: survey_templates
#
#  id                   :integer          not null, primary key
#  survey_template_name :string(255)
#  is_active            :boolean
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class SurveyTemplateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
