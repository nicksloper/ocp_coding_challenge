class BarcodePadService
  def self.call(barcode)
    return nil if barcode.length > 8
    newBarcode = barcode.rjust(8, '0')
    return newBarcode if EAN8.new(newBarcode).valid?
    checkSumBarcode = barcode.rjust(7, '0')
    checkSumBarcode = EAN8.complete(checkSumBarcode)
    return checkSumBarcode if EAN8.new(checkSumBarcode).valid?
    return nil
  end
end