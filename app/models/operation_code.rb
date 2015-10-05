class OperationCode < ActiveRecord::Base
  has_many :operation_code_services
  has_many :services, through: :operation_code_services

  has_many :criterion_operation_codes
  has_many :criterions, through: :criterion_operation_codes
end
