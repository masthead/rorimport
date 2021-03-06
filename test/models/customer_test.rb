# == Schema Information
#
# Table name: customers
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  dealer_id           :integer
#  first_name          :string(255)
#  middle_name         :string(255)
#  last_name           :string(255)
#  home_phone          :string(255)
#  work_phone          :string(255)
#  cell_phone          :string(255)
#  email_address_1     :string(255)
#  email_address_2     :string(255)
#  address_1           :string(255)
#  address_2           :string(255)
#  city_region         :string(255)
#  state_province      :string(255)
#  postal_code         :string(255)
#  do_not_contact_flag :boolean
#  home_phone_dnc_flag :boolean
#  work_phone_dnc_flag :boolean
#  cell_phone_dnc_flag :boolean
#  best_contact_array  :text
#  latitude            :string(255)
#  longitude           :string(255)
#  time_zone           :string(255)
#  address             :string(255)
#  lat_lng             :string(255)
#  search_column       :text
#  distance            :integer
#  parent_id           :integer
#

require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
