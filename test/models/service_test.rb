# == Schema Information
#
# Table name: services
#
#  id                          :integer          not null, primary key
#  created_at                  :datetime
#  updated_at                  :datetime
#  billinghours                :float
#  custgogsale                 :float
#  customerpaygogcost          :float
#  customerpaylaboramount      :float
#  customerpaylaborcost        :float
#  customerpaymisccost         :float
#  customerpaymiscsale         :float
#  customerpaypartscost        :float
#  customerpaypartssale        :float
#  customerpayrepairordertotal :float
#  customerpaysubletcost       :float
#  custsubsale                 :float
#  internalgogcost             :float
#  internallaborcost           :float
#  internallaborsale           :float
#  internalmiscamount          :float
#  internalmisccost            :float
#  internalpartscost           :float
#  internalpartssale           :float
#  internalrepairordertotal    :float
#  internalsubletcost          :float
#  intlgogsale                 :float
#  intlsubsale                 :float
#  laborbillingrate            :float
#  laborcostdollar             :float
#  labordollar                 :float
#  laborhours                  :float
#  labortechnicianrate         :float
#  misccodeamount              :float
#  misccostdollar              :float
#  miscdollar                  :float
#  partscostdollar             :float
#  partsdollar                 :float
#  roamount                    :float
#  rototalcost                 :float
#  totalbillhours              :float
#  totalgogcost                :float
#  totalgogsale                :float
#  totallaborhours             :float
#  totalsubcost                :float
#  totalsubsale                :float
#  totaltax                    :float
#  warrantygogcost             :float
#  warrantylaboramount         :float
#  warrantylaborcost           :float
#  warrantymiscamount          :float
#  warrantymisccost            :float
#  warrantypartjobsale         :float
#  warrantypartscost           :float
#  warrantyrepairordertotal    :float
#  warrantysubletcost          :float
#  warrgogsale                 :float
#  warrsubsale                 :float
#  appointmentflag             :text
#  customeraddress2            :text
#  customermiddlename          :text
#  customersalutation          :text
#  customersuffix              :text
#  deliverymileage             :integer
#  department                  :text
#  emailblock                  :text
#  globaloptout                :text
#  individualbusinessflag      :text
#  laborcomplaint              :text
#  labortypes2                 :text
#  languagepreference          :text
#  mailblock                   :text
#  makeprefix                  :text
#  mechanicnumber              :text
#  mileageout                  :integer
#  misccode                    :text
#  misccodedescription         :text
#  partdescription             :text
#  partnumber                  :text
#  partquantity                :integer
#  phoneblock                  :text
#  pipedcomment                :text
#  pipedcomplaint              :text
#  recommendations             :text
#  recommendedservice          :text
#  rologon                     :text
#  romileage                   :integer
#  rostatus                    :text
#  servicecomment              :text
#  stocknumber                 :text
#  stocktype                   :text
#  tagno                       :text
#  vehiclecolor                :text
#  vehiclemileage              :integer
#  acdealerid                  :text
#  cass_std_cart               :text
#  cass_std_chkdgt             :text
#  cass_std_city               :text
#  cass_std_dpbc               :text
#  cass_std_error_cd           :text
#  cass_std_ews                :text
#  cass_std_fips               :text
#  cass_std_lacs               :text
#  cass_std_lacsrt             :text
#  cass_std_line1              :text
#  cass_std_line2              :text
#  cass_std_lot                :text
#  cass_std_lotord             :text
#  cass_std_ndiapt             :text
#  cass_std_ndirr              :text
#  cass_std_state              :text
#  cass_std_urb                :text
#  cass_std_z4lom              :text
#  cass_std_zip                :text
#  cass_std_zip4               :text
#  cass_std_zipmov             :text
#  clientdealerid              :text
#  custgender                  :text
#  customeraddress             :text
#  customercellphone           :text
#  customercity                :text
#  customeremail               :text
#  customerfirstname           :text
#  customerhomephone           :text
#  customerlastname            :text
#  customername                :text
#  customernumber              :text
#  customerstate               :text
#  customerworkphone           :text
#  customerzip                 :text
#  dmstype                     :text
#  engineconfig                :text
#  filetype                    :text
#  jobstatus                   :text
#  labortypes                  :text
#  modelnum                    :text
#  ncoa_ac_id                  :text
#  operationcode               :text
#  operationdescription        :text
#  paymentmethod               :text
#  ronumber                    :text
#  salesmanname                :text
#  salesmannumber              :text
#  serviceadvisorname          :text
#  serviceadvisornumber        :text
#  technicianname              :text
#  techniciannumber            :text
#  transmission                :text
#  trimlevel                   :text
#  vehiclemake                 :text
#  vehiclemodel                :text
#  vehiclevin                  :text
#  vehicleyear                 :text
#  warrantyexpirationmiles     :text
#  warrantyname                :text
#  roopentime                  :time
#  closeddate                  :datetime
#  customerbirthdate           :datetime
#  deliverydate                :datetime
#  opendate                    :datetime
#  pickupdate                  :datetime
#  promisedate                 :datetime
#  promisetime                 :datetime
#  rocustomerpaypostdate       :datetime
#  roinvoicedate               :datetime
#  warrantyexpirationdate      :datetime
#  customer_id                 :integer
#  s3file_id                   :integer
#  source                      :string(255)
#  dealer_id                   :integer
#  event_id                    :integer
#

require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end