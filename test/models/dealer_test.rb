# == Schema Information
#
# Table name: dealers
#
#  id                         :integer          not null, primary key
#  dealer_focus_id            :string(255)
#  dealer_name                :string(255)
#  dealer_status              :boolean
#  created_at                 :datetime
#  updated_at                 :datetime
#  vendor                     :string(255)
#  slug                       :string(255)
#  address_1                  :string(255)
#  address_2                  :string(255)
#  city_region                :string(255)
#  state_province             :string(255)
#  postal_code                :string(255)
#  time_zone                  :string(255)
#  general_info               :text
#  dealer_message             :text
#  latitude                   :float
#  longitude                  :float
#  address                    :text
#  lat_lng                    :string(255)
#  service_scheduler_id       :integer
#  scheduler_account          :string(255)
#  is_sales_dealer            :boolean
#  is_service_dealer          :boolean
#  is_lead_dealer             :boolean
#  main_phone_number          :string(255)
#  sales_phone_number         :string(255)
#  service_phone_number       :string(255)
#  fax_number                 :string(255)
#  website_address            :string(255)
#  di_caller_id               :boolean
#  is_asr                     :boolean
#  asr_pro_id                 :integer
#  active_date                :datetime
#  inactive_date              :datetime
#  parts_phone_number         :string(255)
#  phone_system               :string(255)
#  dealer_dms_customer_number :string(255)
#  dealer_type_id             :integer
#  go_live_date               :datetime
#  dealer_name_pronunciation  :text
#  crm_vendor_name            :string(255)
#  website_provider_name      :string(255)
#  website_provider_email     :string(255)
#  website_provider_phone     :string(255)
#  dms_ip_address             :string(255)
#  dms_vendor_name            :string(255)
#  crm_vendor_contact         :string(255)
#  crm_vendor_email           :string(255)
#  crm_vendor_phone           :string(255)
#  crm_vendor_mobile          :string(255)
#  crm_username               :string(255)
#  crm_password               :string(255)
#  phone_system_name          :string(255)
#  telephone_circuit          :string(255)
#  call_tracking_company      :string(255)
#  call_tracking_cost         :integer
#  call_tracking_minutes      :integer
#  telephone_vendor_name      :string(255)
#  telephone_vendor_email     :string(255)
#  telephone_vendor_phone     :string(255)
#  telephone_vendor_mobile    :string(255)
#  gps_address                :text
#  services_count             :integer          default(0)
#  sales_count                :integer          default(0)
#  appointments_count         :integer          default(0)
#  calls_count                :integer          default(0)
#  call_records_count         :integer          default(0)
#  prospects_count            :integer          default(0)
#  contacts                   :text
#  send_appointment_alerts    :boolean          default(FALSE)
#

require 'test_helper'

class DealerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
