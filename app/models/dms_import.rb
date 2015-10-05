class DmsImport

  def self.import_file(s3_file_id, force = false)

    s3_file = S3file.find(s3_file_id)

    start_time = Time.now

    puts "Processing #{s3_file.file_type} file: #{s3_file.name}"

    case s3_file.file_type
      when "Appointment"
      then result = push_service_appt_file(s3_file_id, force)
      when "Service"
      then result = push_service_file(s3_file_id, force)
      when "Sale"
      then result = push_sales_file(s3_file_id, force)
    end

    puts "Finished #{s3_file.name} in #{start_time - Time.now} seconds..."
    puts "Breakdown of time:"
    result.each do |k,v|
      puts "#{k} time: #{v}"
    end

  end

  def self.push_service_appt_file(s3_file_id, force)

    result = {}

    s3_file = S3file.find(s3_file_id)

    if !force && (s3_file.total_rows > 0 || s3_file.new_rows > 0)
      s3_file.update(status: 'moved')
    else

      if (s3_file && s3_file.dealer_id.present? && s3_file.status != 'hold' && s3_file.status != 'moved') || force

        file_time_start = Time.now

        s3_file.update(status: 'processing', started_at: Time.now)

        if Rails.env.production? || force
          path = s3_file.download_file
        else
          path = "tmp/#{s3_file.name}"
        end

        result[:file_time] = Time.now - file_time_start

        if File.file?(path)

          # counts the rows in the file
          rows = 0

          # counts new records created
          new_rows = 0

          dealer = Dealer.find(s3_file.dealer_id)

          if dealer && dealer.is_a?(Dealer)

            customer_time = 0
            vehicle_time = 0
            customer_vehicle_time = 0
            record_time = 0

            CSV.foreach(path, { :headers => true, :col_sep => "\t", :skip_blanks => true }) do |row|

              first_name = row[19]
              last_name = row[20]

              if (first_name.nil? || first_name.size == 0) && (last_name.nil? || last_name.size == 0)
                last_name = row[6]
              end

              if /,/.match(last_name)
                first_name = last_name.split(',')[1]
                last_name = last_name.split(',')[0]
              else
                first_name = first_name
              end

              customer_hash = {

                  :first_name         => first_name,
                  :last_name          => last_name,
                  :home_phone         => row[7],
                  :work_phone         => row[27],
                  :cell_phone         => row[25],
                  :email_address_1    => row[8],
                  :address_1          => row[21],
                  :city_region        => row[22],
                  :state_province     => row[23],
                  :postal_code        => row[24],
                  :dealer_id          => dealer.id
              }

              customer_start_time = Time.now
              # create or find the customer
              c = Customer.match_or_create(customer_hash)
              customer_time += Time.now - customer_start_time

              vehicle_start_time = Time.now
              # create or find the vehicle
              v = Vehicle.where(:vin      => row[14]).first_or_create
              vehicle_time += Time.now - vehicle_start_time

              customer_vehicle_start_time = Time.now

              custveh = CustomerVehicle.where(vehicle_id: v.id, customer_id: c.id).first

              unless custveh && custveh.is_a?(CustomerVehicle)
                custveh = CustomerVehicle.create!(vehicle_id: v.id, customer_id: c.id)
              end

              customer_vehicle_time += Time.now - customer_vehicle_start_time

              appointment_start_time = Time.now
              # date and time fields are broken out in file so we put them together
              appointment_datetime = Chronic.parse("#{row[9]} #{row[10]}")

              appt = Appointment.where(
                  :dealer_id              => dealer.id,
                  :first_name             => first_name,
                  :last_name              => last_name,
                  :appointment_datetime   => appointment_datetime
              ).first

              unless appt

                appt = Appointment.create(
                    :dealer_id              => dealer.id,
                    :first_name             => first_name,
                    :last_name              => last_name,
                    :appointment_datetime   => appointment_datetime
                )

                new_rows += 1
              end

              appt.update(
                  :customer_name            =>  row[6],
                  :customer_email           =>  row[8],
                  :service_advisor          =>  row[15],
                  :vehicle_year             =>  row[11],
                  :vehicle_make             =>  row[12],
                  :vehicle_model            =>  row[13],
                  :vin                      =>  row[14],
                  :customer_id              =>  c.id,
                  :dms_appointment_number   =>  row[4],
                  :dms_customer_number      =>  row[26],
                  :s3file_id                =>  s3_file_id
              )

              # if there is a vehicle, update it
              if custveh.present? && custveh.id > 0
                appt.update(customer_vehicle_id: custveh.id)
              end
              record_time += Time.now - appointment_start_time

              rows += 1
            end
            result[:customer_time] = customer_time
            result[:vehicle_time] = vehicle_time
            result[:customer_vehicle_time] = customer_vehicle_time
            result[:record_time] = record_time
            result[:rows_count] = rows
          end

          # update s3file counter
          s3_file.update(:total_rows => rows, :new_rows => new_rows)

          if rows > 0 && Rails.env.production? && DmsImport.move_ons3(s3_file.name)
            s3_file.update(status: "moved", finished_at: Time.now)
          elsif rows > 0 && Rails.env.development?
            s3_file.update(status: "moved", finished_at: Time.now)
          end
        end
      end
    end
    return result
  end

  def self.push_service_file(s3_file_id, force)

    result = {}

    s3_file = S3file.find(s3_file_id)

    if !force && (s3_file.total_rows > 0 || s3_file.new_rows > 0)

      s3_file.update(status: 'moved')
    else

      if (s3_file && s3_file.dealer_id.present? && s3_file.status != 'hold' && s3_file.status != 'moved') || force

        file_time_start = Time.now

        s3_file.update(status: 'processing', started_at: Time.now)

        if Rails.env.production? || force
          path = s3_file.download_file
        else
          path = "tmp/#{s3_file.name}"
        end

        result[:file_time] = Time.now - file_time_start

        if File.file?(path)

          # puts "confirmed file #{s3_file.name}"

          # counts the rows in the file
          rows = 0

          # counts new records created
          new_rows = 0

          # get the dealer id
          dealer = Dealer.find(s3_file.dealer_id)

          if dealer && dealer.is_a?(Dealer)

            customer_time = 0
            vehicle_time = 0
            customer_vehicle_time = 0
            record_time = 0

            CSV.foreach(path, { :headers => true, :col_sep => "\t", :skip_blanks => true }) do |row|

              # puts "Importing service record #{row[4]}"

              # create or find the customer

              first_name = row[8]
              last_name = row[9]

              if (first_name.nil? || first_name.size == 0) && (last_name.nil? || last_name.size == 0)
                last_name = row[7]
              end

              if /,/.match(last_name)
                first_name = last_name.split(',')[1]
                last_name = last_name.split(',')[0]
              else
                first_name = first_name
              end

              customer_hash = {

                  :first_name         => first_name,
                  :last_name          => last_name,
                  :home_phone         => row[14],
                  :work_phone         => row[15],
                  :cell_phone         => row[16],
                  :email_address_1    => row[17],
                  :address_1          => row[10],
                  :city_region        => row[11],
                  :state_province     => row[12],
                  :postal_code        => row[13],
                  :dealer_id          => dealer.id

              }

              customer_start_time = Time.now
              # create or find the customer
              c = Customer.match_or_create(customer_hash)
              customer_time += Time.now - customer_start_time

              vehicle_start_time = Time.now
              # create or find the vehicle
              v = Vehicle.where(:vin      => row[23]).first_or_create
              vehicle_time += Time.now - vehicle_start_time

              customer_vehicle_start_time = Time.now
              custveh = CustomerVehicle.where(vehicle_id: v.id, customer_id: c.id).first

              unless custveh && custveh.is_a?(CustomerVehicle)
                custveh = CustomerVehicle.create!(vehicle_id: v.id, customer_id: c.id)
              end

              customer_vehicle_time += Time.now - customer_vehicle_start_time

              service_start_time = Time.now
              # import the records to the service table
              s = Service.where(
                  :dealer_id        => dealer.id,
                  :clientdealerid   => row[2],
                  :ronumber         => row[4],
                  :rostatus         => row[86]
              ).first

              unless s
                s = Service.create(
                    :dealer_id        => dealer.id,
                    :clientdealerid   => row[2],
                    :ronumber         => row[4],
                    :rostatus         => row[86]
                )

                # increment new rows counter
                new_rows += 1
              end

              s.update(
                  :filetype                                 => row[0],
                  :acdealerid                               => row[1],
                  :dmstype                                  => row[3],
                  :opendate                                 => Chronic.parse(row[5]),
                  :customernumber                           => row[6],
                  :customername                             => row[7],
                  :customerfirstname                        => first_name,
                  :customerlastname                         => last_name,
                  :customeraddress                          => row[10],
                  :customercity                             => row[11],
                  :customerstate                            => row[12],
                  :customerzip                              => row[13],
                  :customerhomephone                        => row[14],
                  :customerworkphone                        => row[15],
                  :customercellphone                        => row[16],
                  :customeremail                            => row[17],
                  :customerbirthdate                        => Chronic.parse(row[18]),
                  :vehiclemileage                           => row[19],
                  :vehicleyear                              => row[20],
                  :vehiclemake                              => row[21],
                  :vehiclemodel                             => row[22],
                  :vehiclevin                               => row[23],
                  :serviceadvisornumber                     => row[24],
                  :serviceadvisorname                       => row[25],
                  :technicianname                           => row[26],
                  :techniciannumber                         => row[27],
                  :deliverydate                             => Chronic.parse(row[28]),
                  :operationcode                            => row[29],
                  :operationdescription                     => row[30],
                  :roamount                                 => row[31],
                  :warrantyname                             => row[32],
                  :warrantyexpirationdate                   => Chronic.parse(row[33]),
                  :warrantyexpirationmiles                  => row[34],
                  :salesmannumber                           => row[35],
                  :salesmanname                             => row[36],
                  :closeddate                               => Chronic.parse(row[37]),
                  :labortypes                               => row[38],
                  :warrantylaboramount                      => row[39],
                  :warrantypartjobsale                      => row[40],
                  :warrantymiscamount                       => row[41],
                  :warrantyrepairordertotal                 => row[42],
                  :internallaborsale                        => row[43],
                  :internalpartssale                        => row[44],
                  :internalmiscamount                       => row[45],
                  :internalrepairordertotal                 => row[46],
                  :customerpaylaboramount                   => row[47],
                  :customerpaypartssale                     => row[48],
                  :customerpaymiscsale                      => row[49],
                  :customerpayrepairordertotal              => row[50],
                  :laborcostdollar                          => row[51],
                  :partscostdollar                          => row[52],
                  :misccostdollar                           => row[53],
                  :miscdollar                               => row[54],
                  :labordollar                              => row[55],
                  :partsdollar                              => row[56],
                  :vehiclecolor                             => row[57],
                  :customerpaypartscost                     => row[58],
                  :customerpaylaborcost                     => row[59],
                  :customerpaygogcost                       => row[60],
                  :customerpaysubletcost                    => row[61],
                  :customerpaymisccost                      => row[62],
                  :warrantypartscost                        => row[63],
                  :warrantylaborcost                        => row[64],
                  :warrantygogcost                          => row[65],
                  :warrantysubletcost                       => row[66],
                  :warrantymisccost                         => row[67],
                  :internalpartscost                        => row[68],
                  :internallaborcost                        => row[69],
                  :internalgogcost                          => row[70],
                  :internalsubletcost                       => row[71],
                  :internalmisccost                         => row[72],
                  :totaltax                                 => row[73],
                  :totallaborhours                          => row[74],
                  :totalbillhours                           => row[75],
                  :servicecomment                           => row[76],
                  :laborcomplaint                           => row[77],
                  :laborbillingrate                         => row[78],
                  :labortechnicianrate                      => row[79],
                  :appointmentflag                          => row[80],
                  :mailblock                                => row[81],
                  :emailblock                               => row[82],
                  :phoneblock                               => row[83],
                  :roinvoicedate                            => Chronic.parse(row[84]),
                  :rocustomerpaypostdate                    => Chronic.parse(row[85]),
                  :mechanicnumber                           => row[87],
                  :romileage                                => row[88],
                  :deliverymileage                          => row[89],
                  :stocknumber                              => row[90],
                  :recommendedservice                       => row[91],
                  :recommendations                          => row[92],
                  :customersuffix                           => row[93],
                  :customersalutation                       => row[94],
                  :customeraddress2                         => row[95],
                  :customermiddlename                       => row[96],
                  :globaloptout                             => row[97],
                  :promisedate                              => Chronic.parse(row[98]),
                  :promisetime                              => row[99],
                  :rologon                                  => row[100],
                  :labortypes2                              => row[101],
                  :languagepreference                       => row[102],
                  :misccode                                 => row[103],
                  :misccodeamount                           => row[104],
                  :partnumber                               => row[105],
                  :partdescription                          => row[106],
                  :partquantity                             => row[107],
                  :misccodedescription                      => row[108],
                  :makeprefix                               => row[109],
                  :department                               => row[110],
                  :rototalcost                              => row[111],
                  :pipedcomplaint                           => row[112],
                  :pipedcomment                             => row[113],
                  :mileageout                               => row[114],
                  :individualbusinessflag                   => row[115],
                  :custgogsale                              => row[116],
                  :laborhours                               => row[117],
                  :billinghours                             => row[118],
                  :tagno                                    => row[119],
                  :stocktype                                => row[120],
                  :roopentime                               => row[121],
                  :custsubsale                              => row[122],
                  :warrgogsale                              => row[123],
                  :warrsubsale                              => row[124],
                  :intlgogsale                              => row[125],
                  :intlsubsale                              => row[126],
                  :totalgogcost                             => row[127],
                  :totalgogsale                             => row[128],
                  :totalsubcost                             => row[129],
                  :totalsubsale                             => row[130],
                  :modelnum                                 => row[131],
                  :transmission                             => row[132],
                  :engineconfig                             => row[133],
                  :trimlevel                                => row[134],
                  :paymentmethod                            => row[135],
                  :pickupdate                               => Chronic.parse(row[136]),
                  :custgender                               => row[137],
                  :jobstatus                                => row[138],
                  :cass_std_line1                           => row[139],
                  :cass_std_line2                           => row[140],
                  :cass_std_city                            => row[141],
                  :cass_std_state                           => row[142],
                  :cass_std_zip                             => row[143],
                  :cass_std_zip4                            => row[144],
                  :cass_std_dpbc                            => row[145],
                  :cass_std_chkdgt                          => row[146],
                  :cass_std_cart                            => row[147],
                  :cass_std_lot                             => row[148],
                  :cass_std_lotord                          => row[149],
                  :cass_std_urb                             => row[150],
                  :cass_std_fips                            => row[151],
                  :cass_std_ews                             => row[152],
                  :cass_std_lacs                            => row[153],
                  :cass_std_zipmov                          => row[154],
                  :cass_std_z4lom                           => row[155],
                  :cass_std_ndiapt                          => row[156],
                  :cass_std_ndirr                           => row[157],
                  :cass_std_lacsrt                          => row[158],
                  :cass_std_error_cd                        => row[159],
                  :ncoa_ac_id                               => row[160],
                  :customer_id                              => c.id,
                  :s3file_id                                => s3_file_id
              )

              # if there is a vehicle, update it
              if custveh.present? && custveh.id > 0
                s.update(customer_vehicle_id: custveh.id)
              end

              record_time += Time.now - service_start_time

              rows += 1
            end
            result[:customer_time] = customer_time
            result[:vehicle_time] = vehicle_time
            result[:customer_vehicle_time] = customer_vehicle_time
            result[:record_time] = record_time
            result[:row_count] = rows
          end

          # update s3file counter
          s3_file.update(:total_rows => rows, :new_rows => new_rows)

          if rows > 0 && Rails.env.production? && DmsImport.move_ons3(s3_file.name)
            s3_file.update(status: "moved", finished_at: Time.now)
          elsif rows > 0 && Rails.env.development?
            s3_file.update(status: "moved", finished_at: Time.now)
          end
        end
      end
    end
    return result
  end

  def self.push_sales_file(s3_file_id, force)

    result = {}

    s3_file = S3file.find(s3_file_id)

    if !force && (s3_file.total_rows > 0 || s3_file.new_rows > 0)

      s3_file.update(status: 'moved')
    else

      if (s3_file && s3_file.dealer_id.present? && s3_file.status != 'hold' && s3_file.status != 'moved') || force

        file_time_start = Time.now

        s3_file.update(status: 'processing', started_at: Time.now)

        if Rails.env.production? || force
          path = s3_file.download_file
        else
          path = "tmp/#{s3_file.name}"
        end

        result[:file_time] = Time.now - file_time_start

        if File.file?(path)

          # puts "confirmed file #{s3_file.name}"

          customer_time = 0
          vehicle_time = 0
          customer_vehicle_time = 0
          record_time = 0

          # counts the rows in the file
          rows = 0

          # counts new records created
          new_rows = 0

          # get the dealer id
          dealer = Dealer.find(s3_file.dealer_id)

          if dealer && dealer.is_a?(Dealer)

            CSV.foreach(path, { :headers => true, :col_sep => "\t", :skip_blanks => true }) do |row|

              # puts "Importing sale record #{row[4]}"

              # create or find the customer
              first_name = row[7]
              last_name = row[8]

              if (first_name.nil? || first_name.size == 0) && (last_name.nil? || last_name.size == 0)
                last_name = row[6]
              end

              if /,/.match(last_name)
                first_name = last_name.split(',')[1]
                last_name = last_name.split(',')[0]
              else
                first_name = first_name
              end

              customer_hash = {

                  :first_name           => first_name,
                  :last_name            => last_name,
                  :home_phone           => row[14],
                  :work_phone           => row[15],
                  :cell_phone           => row[16],
                  :email_address_1      => row[18],
                  :address_1            => row[9],
                  :city_region          => row[10],
                  :state_province       => row[11],
                  :postal_code          => row[12],
                  :dealer_id            => dealer.id

              }

              customer_start_time = Time.now
              # create or find the customer
              c = Customer.match_or_create(customer_hash)
              customer_time += Time.now - customer_start_time

              vehicle_start_time = Time.now
              # create or find the vehicle
              v = Vehicle.where(:vin      => row[48]).first_or_create
              vehicle_time += Time.now - vehicle_start_time

              customer_vehicle_start_time = Time.now
              custveh = CustomerVehicle.where(vehicle_id: v.id, customer_id: c.id).first

              unless custveh && custveh.is_a?(CustomerVehicle)
                custveh = CustomerVehicle.create!(vehicle_id: v.id, customer_id: c.id)
              end

              customer_vehicle_time += Time.now - customer_vehicle_start_time

              sale_start_time = Time.now

              # import the records to the service table
              sl = Sale.where(
                  :dealer_id            => dealer.id,
                  :dealnumber           => row[4]
              ).first

              unless sl
                sl = Sale.create(
                    :dealer_id            => dealer.id,
                    :dealnumber           => row[4]
                )

                new_rows += 1
              end

              if row[238]
                leasemiles = row[238].gsub(/[^0-9]/, "")
              else
                leasemiles = 0
              end

              sl.update(
                  :clientdealerid                         => row[2],
                  :customer_id                            => c.id,
                  :s3file_id                              => s3_file_id,
                  :filetype                               => row[0],
                  :acdealerid                             => row[1],
                  :dmstype                                => row[3],
                  :customernumber                         => row[5],
                  :customername                           => row[6],
                  :customerfirstname                      => first_name,
                  :customerlastname                       => last_name,
                  :customeraddress                        => row[9],
                  :customercity                           => row[10],
                  :customerstate                          => row[11],
                  :customerzip                            => row[12],
                  :customercounty                         => row[13],
                  :customerhomephone                      => row[14],
                  :customerworkphone                      => row[15],
                  :customercellphone                      => row[16],
                  :customerpagerphone                     => row[17],
                  :customeremail                          => row[18],
                  :customerbirthdate                      => Chronic.parse(row[19]),
                  :mailblock                              => row[20],
                  :cobuyername                            => row[21],
                  :cobuyerfirstname                       => row[22],
                  :cobuyerlastname                        => row[23],
                  :cobuyeraddress                         => row[24],
                  :cobuyercity                            => row[25],
                  :cobuyerstate                           => row[26],
                  :cobuyerzip                             => row[27],
                  :cobuyercounty                          => row[28],
                  :cobuyerhomephone                       => row[29],
                  :cobuyerworkphone                       => row[30],
                  :cobuyerbirthdate                       => Chronic.parse(row[31]),
                  :salesman_1_number                      => row[32],
                  :salesman_1_name                        => row[33],
                  :salesman_2_number                      => row[34],
                  :salesman_2_name                        => row[35],
                  :closingmanagername                     => row[36],
                  :closingmanagernumber                   => row[37],
                  :f_and_i_managernumber                  => row[38],
                  :f_and_i_managername                    => row[39],
                  :salesmanagernumber                     => row[40],
                  :salesmanagername                       => row[41],
                  :entrydate                              => Chronic.parse(row[42]),
                  :dealbookdate                           => Chronic.parse(row[43]),
                  :vehicleyear                            => row[44],
                  :vehiclemake                            => row[45],
                  :vehiclemodel                           => row[46],
                  :vehiclestocknumber                     => row[47],
                  :vehiclevin                             => row[48],
                  :vehicleexteriorcolor                   => row[49],
                  :vehicleinteriorcolor                   => row[50],
                  :vehiclemileage                         => row[51],
                  :vehicletype                            => row[52],
                  :inservicedate                          => Chronic.parse(row[53]),
                  :holdbackamount                         => row[54],
                  :dealtype                               => row[55],
                  :saletype                               => row[56],
                  :bankcode                               => row[57],
                  :bankname                               => row[58],
                  :salesmancommission                     => row[59],
                  :grossprofitsale                        => row[60],
                  :financereserve                         => row[61],
                  :creditlifepremium                      => row[62],
                  :creditlifecommision                    => row[63],
                  :totalinsurancereserve                  => row[64],
                  :balloonamount                          => row[65],
                  :cashprice                              => row[66],
                  :amountfinanced                         => row[67],
                  :totalofpayments                        => row[68],
                  :msrp                                   => row[69],
                  :downpayment                            => row[70],
                  :securitydesposit                       => row[71],
                  :rebate                                 => row[72],
                  :term                                   => row[73],
                  :retailpayment                          => row[74],
                  :paymenttype                            => row[75],
                  :retailfirstpaydate                     => Chronic.parse(row[76]),
                  :leasefirstpaydate                      => Chronic.parse(row[77]),
                  :daytofirstpayment                      => row[78],
                  :leaseannualmiles                       => row[79],
                  :mileagerate                            => row[80],
                  :aprrate                                => row[81],
                  :residualamount                         => row[82],
                  :licensefee                             => row[83],
                  :registrationfee                        => row[84],
                  :totaltax                               => row[85],
                  :extendedwarrantyname                   => row[86],
                  :extendedwarrantyterm                   => row[87],
                  :extendedwarrantylimitmiles             => row[88],
                  :extendedwarrantydollar                 => row[89],
                  :extendedwarrantyprofit                 => row[90],
                  :frontgross                             => row[91],
                  :backgross                              => row[92],
                  :tradein_1_vin                          => row[93],
                  :tradein_2_vin                          => row[94],
                  :tradein_1_make                         => row[95],
                  :tradein_2_make                         => row[96],
                  :tradein_1_model                        => row[97],
                  :tradein_2_model                        => row[98],
                  :tradein_1_exteriorcolor                => row[99],
                  :tradein_2_exteriorcolor                => row[100],
                  :tradein_1_year                         => row[101],
                  :tradein_2_year                         => row[102],
                  :tradein_1_mileage                      => row[103],
                  :tradein_2_mileage                      => row[104],
                  :tradein_1_gross                        => row[105],
                  :tradein_2_gross                        => row[106],
                  :tradein_1_payoff                       => row[107],
                  :tradein_2_payoff                       => row[108],
                  :tradein_1_acv                          => row[109],
                  :tradein_2_acv                          => row[110],
                  :fee_1_name                             => row[111],
                  :fee_1_fee                              => row[112],
                  :fee_1_commission                       => row[113],
                  :fee_2_name                             => row[114],
                  :fee_2_fee                              => row[115],
                  :fee_2_commission                       => row[116],
                  :fee_3_name                             => row[117],
                  :fee_3_fee                              => row[118],
                  :fee_3_commission                       => row[119],
                  :fee_4_name                             => row[120],
                  :fee_4_fee                              => row[121],
                  :fee_4_commission                       => row[122],
                  :fee_5_name                             => row[123],
                  :fee_5_fee                              => row[124],
                  :fee_5_commission                       => row[125],
                  :fee_6_name                             => row[126],
                  :fee_6_fee                              => row[127],
                  :fee_6_commission                       => row[128],
                  :fee_7_name                             => row[129],
                  :fee_7_fee                              => row[130],
                  :fee_7_commission                       => row[131],
                  :fee_8_name                             => row[132],
                  :fee_8_fee                              => row[133],
                  :fee_8_commission                       => row[134],
                  :fee_9_name                             => row[135],
                  :fee_9_fee                              => row[136],
                  :fee_9_commission                       => row[137],
                  :fee_10_name                            => row[138],
                  :fee_10_fee                             => row[139],
                  :fee_10_commission                      => row[140],
                  :contractdate                           => Chronic.parse(row[141]),
                  :insurancename                          => row[142],
                  :insuranceagentname                     => row[143],
                  :insuranceaddress                       => row[144],
                  :insurancecity                          => row[145],
                  :insurancestate                         => row[146],
                  :insurancezip                           => row[147],
                  :insurancephone                         => row[148],
                  :insurancepolicynumber                  => row[149],
                  :insuranceeffectivedate                 => Chronic.parse(row[150]),
                  :insuranceexpirationdate                => Chronic.parse(row[151]),
                  :insurancecompensationdeduction         => row[152],
                  :tradein_1_interiorcolor                => row[153],
                  :tradein_2_interiorcolor                => row[154],
                  :phoneblock                             => row[155],
                  :licenseplatenumber                     => row[156],
                  :cost                                   => row[157],
                  :invoiceamount                          => row[158],
                  :financecharge                          => row[159],
                  :totalpickuppayment                     => row[160],
                  :totalaccessories                       => row[161],
                  :totaldriveoffamount                    => row[162],
                  :emailblock                             => row[163],
                  :modeldescriptionofcarsold              => row[164],
                  :vehicleclassification                  => row[165],
                  :modelnumberofcarsold                   => row[166],
                  :gappremium                             => row[167],
                  :lastinstallmentdate                    => Chronic.parse(row[168]),
                  :cashdeposit                            => row[169],
                  :ahpremium                              => row[170],
                  :leaserate                              => row[171],
                  :dealerselect                           => row[172],
                  :leasepayment                           => row[173],
                  :leasenetcapcost                        => row[174],
                  :leasetotalcapreduction                 => row[175],
                  :dealstatus                             => row[176],
                  :customersuffix                         => row[177],
                  :customersalutation                     => row[178],
                  :customeraddress2                       => row[179],
                  :customermiddlename                     => row[180],
                  :globaloptout                           => row[181],
                  :leaseterm                              => row[182],
                  :extendedwarrantyflag                   => row[183],
                  :salesman_3_number                      => row[184],
                  :salesman_3_name                        => row[185],
                  :salesman_4_number                      => row[186],
                  :salesman_4_name                        => row[187],
                  :salesman_5_number                      => row[188],
                  :salesman_5_name                        => row[189],
                  :salesman_6_number                      => row[190],
                  :salesman_6_name                        => row[191],
                  :aprrate2                               => row[192],
                  :aprrate3                               => row[193],
                  :aprrate4                               => row[194],
                  :term2                                  => row[195],
                  :securitydeposit2                       => row[196],
                  :downpayment2                           => row[197],
                  :totalofpayments2                       => row[198],
                  :basepayment                            => row[199],
                  :journalsaleamount                      => row[200],
                  :individualbusinessflag                 => row[201],
                  :inventorydate                          => Chronic.parse(row[202]),
                  :statusdate                             => Chronic.parse(row[203]),
                  :listprice                              => row[204],
                  :nettradeamount                         => row[205],
                  :trimlevel                              => row[206],
                  :subtrimlevel                           => row[207],
                  :bodydescription                        => row[208],
                  :bodydoorcount                          => row[209],
                  :transmissiondesc                       => row[210],
                  :enginedesc                             => row[211],
                  :typecode                               => row[212],
                  :slct2                                  => row[213],
                  :dealdateoffset                         => row[214],
                  :accountingdate                         => Chronic.parse(row[215]),
                  :cobuyercustnum                         => row[216],
                  :cobuyercell                            => row[217],
                  :cobuyeremail                           => row[218],
                  :cobuyersalutation                      => row[219],
                  :cobuyerphoneblock                      => row[220],
                  :cobuyermailblock                       => row[221],
                  :cobuyeremailblock                      => row[222],
                  :realbookdate                           => Chronic.parse(row[223]),
                  :cobuyermiddlename                      => row[224],
                  :cobuyercountry                         => row[225],
                  :cobuyeraddress2                        => row[226],
                  :cobuyeroptout                          => row[227],
                  :cobuyeroccupation                      => row[228],
                  :cobuyeremployer                        => row[229],
                  :country                                => row[230],
                  :occupation                             => row[231],
                  :employer                               => row[232],
                  :salesman2commission                    => row[233],
                  :bankaddress                            => row[234],
                  :bankcity                               => row[235],
                  :bankstate                              => row[236],
                  :bankzip                                => row[237],
                  :leaseestimatedmiles                    => leasemiles,
                  :aftreserve                             => row[239],
                  :creditlifeprem                         => row[240],
                  :creditliferes                          => row[241],
                  :ahres                                  => row[242],
                  :language                               => row[243],
                  :buyrate                                => row[244],
                  :dmvamount                              => row[245],
                  :weight                                 => row[246],
                  :statedmvtotfee                         => row[247],
                  :rosnumber                              => row[248],
                  :incentives                             => row[249],
                  :cass_std_line1                         => row[250],
                  :cass_std_line2                         => row[251],
                  :cass_std_city                          => row[252],
                  :cass_std_state                         => row[253],
                  :cass_std_zip                           => row[254],
                  :cass_std_zip4                          => row[255],
                  :cass_std_dpbc                          => row[256],
                  :cass_std_chkdgt                        => row[257],
                  :cass_std_cart                          => row[258],
                  :cass_std_lot                           => row[259],
                  :cass_std_lotord                        => row[260],
                  :cass_std_urb                           => row[261],
                  :cass_std_fips                          => row[262],
                  :cass_std_ews                           => row[263],
                  :cass_std_lacs                          => row[264],
                  :cass_std_zipmov                        => row[265],
                  :cass_std_z4lom                         => row[266],
                  :cass_std_ndiapt                        => row[267],
                  :cass_std_ndirr                         => row[268],
                  :cass_std_lacsrt                        => row[269],
                  :cass_std_error_cd                      => row[270],
                  :ncoa_ac_id                             => row[271]
              )

              # if there is a vehicle, update it
              if custveh.present? && custveh.id > 0
                sl.update(customer_vehicle_id: custveh.id)
              end
              record_time += Time.now - sale_start_time

              rows += 1
            end
            result[:customer_time] = customer_time
            result[:vehicle_time] = vehicle_time
            result[:customer_vehicle_time] = customer_vehicle_time
            result[:record_time] = record_time
            result[:row_count] = rows
          end

          # update s3file counter
          s3_file.update(:total_rows => rows, :new_rows => new_rows)

          if rows > 0 && Rails.env.production? && DmsImport.move_ons3(s3_file.name)
            s3_file.update(status: "moved", finished_at: Time.now)
          elsif rows > 0 && Rails.env.development?
            s3_file.update(status: "moved", finished_at: Time.now)
          end
        end
      end
    end

    return result

  end

  def self.move_ons3(s3_filename)

    s3_config = AwsUtils.s3_config

    begin
      AwsUtils.move_buckets(s3_filename, s3_config["S3_BUCKET_INBOUND"], s3_config["S3_BUCKET_ARCHIVE"])
    end
  end

end