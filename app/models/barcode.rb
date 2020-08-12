class Barcode < ActiveRecord::Base
  validates_uniqueness_of :barcode
  validate :isEan8

  def isEan8
    errors.add(:barcode, "is not EAN8.") unless EAN8.new(barcode).valid?
  end

end
