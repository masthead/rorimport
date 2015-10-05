 class SaleDatum < ActiveRecord::Base

  belongs_to :customer_vehicle

  has_many :provider_sale_data, :foreign_key => :sale_data_id
  has_many :providers, :through => :provider_sale_data

  enum vehicle_type: { new_vehicle: 1, used_vehicle: 2 }
  enum purchase_type: { cash_purchase: 1, lease_purchase: 2, finance_purchase: 3 }

  def get_sales_data
    if self.customer_vehicle && self.customer_vehicle.sale
      sale = self.customer_vehicle.sale
      if sale.trades.count > 0 && sale.trades.first.match(/^[A-Za-z0-9]{17}+$/)
        self.trade_vin = sale.trades.first
      end

      self.vehicle_type = sale.get_vehicle_type
      self.purchase_type = sale.get_purchase_type

      if self.payment_term.present?
         p_term = self.payment_term
      else
        if self.purchase_type == 'lease_purchase'
          p_term = sale.leaseterm
        else
          p_term = sale.term
        end

        self.payment_term = p_term if p_term.present?
      end

      if p_term.present?
        term_in_years =  (p_term / 12).to_i
        self.lease_expiration_date = sale.dealbookdate + term_in_years.years if sale.dealbookdate.present?

        lease_total_miles = self.lease_annual_miles.nil? ? 0 : self.lease_annual_miles * term_in_years
      else
        lease_total_miles = sale.leaseestimatedmiles
      end

      self.lease_expiration_miles = sale.vehiclemileage.to_i + lease_total_miles

      if sale.extendedwarrantyterm.present?
        warranty_term_in_years = (sale.extendedwarrantyterm.to_i / 12).to_i
        self.warranty_expiration_date = sale.dealbookdate + warranty_term_in_years.years if sale.dealbookdate.present?
      end

      self.warranty_expiration_miles = sale.vehiclemileage.to_i + sale.extendedwarrantylimitmiles.to_i

      if self.purchase_type == 'lease_purchase'
        self.payment = sale.leasepayment
      else
        self.payment = sale.retailpayment
      end

      self.gross_profit       = sale.grossprofitsale
      self.salesperson_number = sale.salesman_1_number
      self.salesperson_name   = sale.salesman_1_name
      self.amount_financed    = sale.amountfinanced

      if self.purchase_type == 'lease_purchase'
        self.down_payment = sale.leasetotalcapreduction
      else
        self.down_payment = sale.downpayment
      end

      if self.purchase_type == 'lease_purchase'
      else
        self.apr = sale.aprrate
      end

      if self.purchase_type == 'lease_purchase'
        self.lease_annual_miles = sale.leaseannualmiles.to_i
        self.lease_mileage_rate = sale.mileagerate.to_f
        self.lease_residual = sale.residualamount.to_f
        self.lease_total_cap_cost = sale.leasenetcapcost
      end

      self.lease_rate = sale.leaserate

      bank_info = sale.bankname || sale.bankcode
      if bank_info.present? && self.customer_vehicle.try(:customer).try(:dealer).present?
        provider = self.providers.where(:provider_type => 'bank', :name => bank_info, :dealer => self.customer_vehicle.customer.dealer).first_or_create
        self.provider_sale_data.create(:provider => provider, :sale_datum => self)
      end

      if sale.extendedwarrantyname.present? && self.customer_vehicle.try(:customer).try(:dealer).present?
        provider = self.providers.where(:provider_type => 'warranty', :name => sale.extendedwarrantyname, :dealer => self.customer_vehicle.customer.dealer).first_or_create
        self.provider_sale_data.create(:provider => provider, :sale_datum => self)
      end

      self.save!
    end
  end
end