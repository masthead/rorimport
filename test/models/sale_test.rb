# == Schema Information
#
# Table name: sales
#
#  id                             :integer          not null, primary key
#  dealer_id                      :integer
#  customer_id                    :integer
#  s3file_id                      :integer
#  created_at                     :datetime
#  updated_at                     :datetime
#  filetype                       :string(255)
#  acdealerid                     :string(255)
#  dmstype                        :string(255)
#  customernumber                 :string(255)
#  customername                   :string(255)
#  customerfirstname              :string(255)
#  customerlastname               :string(255)
#  customeraddress                :string(255)
#  customercity                   :string(255)
#  customerstate                  :string(255)
#  customerzip                    :string(255)
#  customercounty                 :string(255)
#  customerhomephone              :string(255)
#  customerworkphone              :string(255)
#  customercellphone              :string(255)
#  customerpagerphone             :string(255)
#  customeremail                  :string(255)
#  customerbirthdate              :datetime
#  mailblock                      :string(255)
#  cobuyername                    :string(255)
#  cobuyerfirstname               :string(255)
#  cobuyerlastname                :string(255)
#  cobuyeraddress                 :string(255)
#  cobuyercity                    :string(255)
#  cobuyerstate                   :string(255)
#  cobuyerzip                     :string(255)
#  cobuyercounty                  :string(255)
#  cobuyerhomephone               :string(255)
#  cobuyerworkphone               :string(255)
#  cobuyerbirthdate               :datetime
#  salesman_1_number              :string(255)
#  salesman_1_name                :string(255)
#  salesman_2_number              :string(255)
#  salesman_2_name                :string(255)
#  closingmanagername             :string(255)
#  closingmanagernumber           :string(255)
#  f_and_i_managernumber          :string(255)
#  f_and_i_managername            :string(255)
#  salesmanagernumber             :string(255)
#  salesmanagername               :string(255)
#  entrydate                      :datetime
#  dealbookdate                   :datetime
#  vehicleyear                    :string(255)
#  vehiclemake                    :string(255)
#  vehiclemodel                   :string(255)
#  vehiclestocknumber             :string(255)
#  vehiclevin                     :string(255)
#  vehicleexteriorcolor           :string(255)
#  vehicleinteriorcolor           :string(255)
#  vehiclemileage                 :string(255)
#  vehicletype                    :string(255)
#  inservicedate                  :datetime
#  holdbackamount                 :decimal(, )
#  dealtype                       :string(255)
#  saletype                       :string(255)
#  bankcode                       :string(255)
#  bankname                       :string(255)
#  salesmancommission             :decimal(, )
#  grossprofitsale                :decimal(, )
#  financereserve                 :decimal(, )
#  creditlifepremium              :decimal(, )
#  creditlifecommision            :decimal(, )
#  totalinsurancereserve          :decimal(, )
#  balloonamount                  :decimal(, )
#  cashprice                      :decimal(, )
#  amountfinanced                 :decimal(, )
#  totalofpayments                :decimal(, )
#  msrp                           :decimal(, )
#  downpayment                    :decimal(, )
#  securitydesposit               :decimal(, )
#  rebate                         :decimal(, )
#  term                           :decimal(, )
#  retailpayment                  :decimal(, )
#  paymenttype                    :string(255)
#  retailfirstpaydate             :datetime
#  leasefirstpaydate              :datetime
#  daytofirstpayment              :string(255)
#  leaseannualmiles               :decimal(, )
#  mileagerate                    :decimal(, )
#  aprrate                        :decimal(, )
#  residualamount                 :decimal(, )
#  licensefee                     :decimal(, )
#  registrationfee                :decimal(, )
#  totaltax                       :decimal(, )
#  extendedwarrantyname           :string(255)
#  extendedwarrantyterm           :string(255)
#  extendedwarrantylimitmiles     :decimal(, )
#  extendedwarrantydollar         :decimal(, )
#  extendedwarrantyprofit         :decimal(, )
#  frontgross                     :decimal(, )
#  backgross                      :decimal(, )
#  tradein_1_vin                  :string(255)
#  tradein_2_vin                  :string(255)
#  tradein_1_make                 :string(255)
#  tradein_2_make                 :string(255)
#  tradein_1_model                :string(255)
#  tradein_2_model                :string(255)
#  tradein_1_exteriorcolor        :string(255)
#  tradein_2_exteriorcolor        :string(255)
#  tradein_1_year                 :string(255)
#  tradein_2_year                 :string(255)
#  tradein_1_mileage              :string(255)
#  tradein_2_mileage              :string(255)
#  tradein_1_gross                :decimal(, )
#  tradein_2_gross                :decimal(, )
#  tradein_1_payoff               :decimal(, )
#  tradein_2_payoff               :decimal(, )
#  tradein_1_acv                  :decimal(, )
#  tradein_2_acv                  :decimal(, )
#  fee_1_name                     :string(255)
#  fee_1_fee                      :decimal(, )
#  fee_1_commission               :decimal(, )
#  fee_2_name                     :string(255)
#  fee_2_fee                      :decimal(, )
#  fee_2_commission               :decimal(, )
#  fee_3_name                     :string(255)
#  fee_3_fee                      :decimal(, )
#  fee_3_commission               :decimal(, )
#  fee_4_name                     :string(255)
#  fee_4_fee                      :decimal(, )
#  fee_4_commission               :decimal(, )
#  fee_5_name                     :string(255)
#  fee_5_fee                      :decimal(, )
#  fee_5_commission               :decimal(, )
#  fee_6_name                     :string(255)
#  fee_6_fee                      :decimal(, )
#  fee_6_commission               :decimal(, )
#  fee_7_name                     :string(255)
#  fee_7_fee                      :decimal(, )
#  fee_7_commission               :decimal(, )
#  fee_8_name                     :string(255)
#  fee_8_fee                      :decimal(, )
#  fee_8_commission               :decimal(, )
#  fee_9_name                     :string(255)
#  fee_9_fee                      :decimal(, )
#  fee_9_commission               :decimal(, )
#  fee_10_name                    :string(255)
#  fee_10_fee                     :decimal(, )
#  fee_10_commission              :decimal(, )
#  contractdate                   :datetime
#  insurancename                  :string(255)
#  insuranceagentname             :string(255)
#  insuranceaddress               :string(255)
#  insurancecity                  :string(255)
#  insurancestate                 :string(255)
#  insurancezip                   :string(255)
#  insurancephone                 :string(255)
#  insurancepolicynumber          :string(255)
#  insuranceeffectivedate         :datetime
#  insuranceexpirationdate        :datetime
#  insurancecompensationdeduction :string(255)
#  tradein_1_interiorcolor        :string(255)
#  tradein_2_interiorcolor        :string(255)
#  phoneblock                     :string(255)
#  licenseplatenumber             :string(255)
#  cost                           :decimal(, )
#  invoiceamount                  :decimal(, )
#  financecharge                  :decimal(, )
#  totalpickuppayment             :decimal(, )
#  totalaccessories               :decimal(, )
#  totaldriveoffamount            :decimal(, )
#  emailblock                     :string(255)
#  modeldescriptionofcarsold      :string(255)
#  vehicleclassification          :string(255)
#  modelnumberofcarsold           :string(255)
#  gappremium                     :decimal(, )
#  lastinstallmentdate            :datetime
#  cashdeposit                    :decimal(, )
#  ahpremium                      :decimal(, )
#  leaserate                      :decimal(, )
#  dealerselect                   :string(255)
#  leasepayment                   :decimal(, )
#  leasenetcapcost                :decimal(, )
#  leasetotalcapreduction         :decimal(, )
#  dealstatus                     :string(255)
#  customersuffix                 :string(255)
#  customersalutation             :string(255)
#  customeraddress2               :string(255)
#  customermiddlename             :string(255)
#  globaloptout                   :string(255)
#  leaseterm                      :decimal(, )
#  extendedwarrantyflag           :string(255)
#  salesman_3_number              :string(255)
#  salesman_3_name                :string(255)
#  salesman_4_number              :string(255)
#  salesman_4_name                :string(255)
#  salesman_5_number              :string(255)
#  salesman_5_name                :string(255)
#  salesman_6_number              :string(255)
#  salesman_6_name                :string(255)
#  aprrate2                       :decimal(, )
#  aprrate3                       :decimal(, )
#  aprrate4                       :decimal(, )
#  term2                          :decimal(, )
#  securitydeposit2               :decimal(, )
#  downpayment2                   :decimal(, )
#  totalofpayments2               :decimal(, )
#  basepayment                    :decimal(, )
#  journalsaleamount              :decimal(, )
#  individualbusinessflag         :string(255)
#  inventorydate                  :datetime
#  statusdate                     :datetime
#  listprice                      :decimal(, )
#  nettradeamount                 :decimal(, )
#  trimlevel                      :string(255)
#  subtrimlevel                   :string(255)
#  bodydescription                :string(255)
#  bodydoorcount                  :string(255)
#  transmissiondesc               :string(255)
#  enginedesc                     :string(255)
#  typecode                       :string(255)
#  slct2                          :string(255)
#  dealdateoffset                 :string(255)
#  accountingdate                 :datetime
#  cobuyercustnum                 :string(255)
#  cobuyercell                    :string(255)
#  cobuyeremail                   :string(255)
#  cobuyersalutation              :string(255)
#  cobuyerphoneblock              :string(255)
#  cobuyermailblock               :string(255)
#  cobuyeremailblock              :string(255)
#  realbookdate                   :datetime
#  cobuyermiddlename              :string(255)
#  cobuyercountry                 :string(255)
#  cobuyeraddress2                :string(255)
#  cobuyeroptout                  :string(255)
#  cobuyeroccupation              :string(255)
#  cobuyeremployer                :string(255)
#  country                        :string(255)
#  occupation                     :string(255)
#  employer                       :string(255)
#  salesman2commission            :decimal(, )
#  bankaddress                    :string(255)
#  bankcity                       :string(255)
#  bankstate                      :string(255)
#  bankzip                        :string(255)
#  leaseestimatedmiles            :decimal(, )
#  aftreserve                     :decimal(, )
#  creditlifeprem                 :decimal(, )
#  creditliferes                  :decimal(, )
#  ahres                          :decimal(, )
#  language                       :string(255)
#  buyrate                        :decimal(, )
#  dmvamount                      :decimal(, )
#  weight                         :string(255)
#  statedmvtotfee                 :string(255)
#  rosnumber                      :string(255)
#  incentives                     :string(255)
#  cass_std_line1                 :string(255)
#  cass_std_line2                 :string(255)
#  cass_std_city                  :string(255)
#  cass_std_state                 :string(255)
#  cass_std_zip                   :string(255)
#  cass_std_zip4                  :string(255)
#  cass_std_dpbc                  :string(255)
#  cass_std_chkdgt                :string(255)
#  cass_std_cart                  :string(255)
#  cass_std_lot                   :string(255)
#  cass_std_lotord                :string(255)
#  cass_std_urb                   :string(255)
#  cass_std_fips                  :string(255)
#  cass_std_ews                   :string(255)
#  cass_std_lacs                  :string(255)
#  cass_std_zipmov                :string(255)
#  cass_std_z4lom                 :string(255)
#  cass_std_ndiapt                :string(255)
#  cass_std_ndirr                 :string(255)
#  cass_std_lacsrt                :string(255)
#  cass_std_error_cd              :string(255)
#  ncoa_ac_id                     :string(255)
#  clientdealerid                 :string(255)
#  dealnumber                     :string(255)
#  event_id                       :integer
#

require 'test_helper'

class SaleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
