class OperationCodeService < ActiveRecord::Base

  belongs_to :operation_code
  belongs_to :service
end