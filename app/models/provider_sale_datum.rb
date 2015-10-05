class ProviderSaleDatum < ActiveRecord::Base

  belongs_to :sale_datum, :foreign_key => :sale_data_id
  belongs_to :provider, :foreign_key => :provider_id

end