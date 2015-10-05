# == Schema Information
#
# Table name: upload_customers
#
#  id                :integer          not null, primary key
#  first_name        :string(255)
#  last_name         :string(255)
#  address_1         :string(255)
#  address_2         :string(255)
#  city_region       :string(255)
#  state_province    :string(255)
#  postal_code       :string(255)
#  home_phone        :string(255)
#  work_phone        :string(255)
#  cell_phone        :string(255)
#  email_address     :string(255)
#  vin               :string(255)
#  vehicle_year      :string(255)
#  vehicle_make      :string(255)
#  vehicle_model     :string(255)
#  vehicle_mileage   :string(255)
#  last_service_date :date
#  sale_date         :date
#  upload_file_id    :integer
#  created_at        :datetime
#  updated_at        :datetime
#  customer_id       :integer
#

require 'test_helper'

class UploadCustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
