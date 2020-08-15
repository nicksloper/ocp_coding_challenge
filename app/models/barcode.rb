class Barcode < ActiveRecord::Base
  validates :code, uniqueness: true
end