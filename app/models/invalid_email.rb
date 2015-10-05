# == Schema Information
#
# Table name: invalid_emails
#
#  id            :integer          not null, primary key
#  email_address :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class InvalidEmail < ActiveRecord::Base

  validates_uniqueness_of :email_address, :allow_nil => false, :allow_blank => false

  before_save :set_to_lower

  def set_to_lower
    self.email_address = self.email_address.downcase
  end

end
