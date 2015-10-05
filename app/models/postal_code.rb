class PostalCode < ActiveRecord::Base
  has_many :criterion_postal_codes
  has_many :criterions, :through => :criterion_postal_codes

  belongs_to :dealer

  validates :dealer_id, :uniqueness => { :scope => :value }, :allow_nil => false, :allow_blank => false

end
