class Barcode < ActiveRecord::Base
  validates :code, presence: true
  validates :source, presence: true
end
