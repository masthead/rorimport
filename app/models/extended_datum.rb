class ExtendedDatum < ActiveRecord::Base
  belongs_to :extended, polymorphic: true
end
