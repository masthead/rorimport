class Provider < ActiveRecord::Base

  belongs_to :dealer

  has_many :provider_sale_data
  has_many :providers, :through => :provider_sale_data

  validates_uniqueness_of :dealer_id, :scope => [:provider_type, :name]
end