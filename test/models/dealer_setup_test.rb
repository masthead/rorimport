# == Schema Information
#
# Table name: dealer_setups
#
#  id            :integer          not null, primary key
#  dealer_id     :integer
#  setup_task_id :integer
#  completed     :boolean          default(FALSE)
#  user_id       :integer
#  notes         :text
#  priority      :integer
#  completed_at  :datetime
#  created_at    :datetime
#  updated_at    :datetime
#  completed_by  :integer
#

require 'test_helper'

class DealerSetupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
