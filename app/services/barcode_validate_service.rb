class BarcodeValidateService

  # Takes in barcode, checks if valid, checks if barcode already exists, pads if necessary
  # Return:
  #   Valid: If the barcode is valid - boolean
  #   barcode: The original or padded barcode - string
  #   error: Associated error message, if any, else nil - string
  def self.call(barcode)
    return {valid: false, barcode: barcode, error: ' is too large. '} if barcode.length > 8 # barcode is too long
    barcode_exists = Barcode.where(barcode: barcode).any?
    is_EAN8 = EAN8.new(barcode).valid?
    return {valid: false, barcode: barcode, error: ' already exists. '} if barcode_exists # barcode already exists
    return {valid: true, barcode: barcode, error: nil} if is_EAN8 # barcode is valid
    newBarcode = BarcodePadService.call(barcode)
    return {valid: false, barcode: barcode, error: ' is not EAN8 compatible. '} unless newBarcode # barcode has invalid checksum or is not integers
    newBarcode_exists = Barcode.where(barcode: newBarcode).any?
    return {valid: false, barcode: barcode, error: ' already exists. '} if newBarcode_exists # barcode already exists
    return {valid: true, barcode: newBarcode, error: nil} # new barcode is valid
  end
  
end