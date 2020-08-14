class Barcodes::PadIncompleteBarcodeService < ServiceObject
  attr_reader :barcode

  def execute
    return barcode unless barcode_is_too_short?
    return complete_barcode
  end

  private

  def initialize_attributes(options)
    @barcode = options[:barcode]
  end

  def barcode_is_too_short?
    return barcode.length < 8
  end

  def complete_barcode
    complete_barcode = barcode.rjust(8, '0') # Pad with zeroes to the left of the barcode, up to 8 digits
    if barcode_ean8_is_invalid?(complete_barcode)
      complete_barcode = barcode.rjust(7, '0')
      complete_barcode = EAN8.complete(complete_barcode)
    end

    return complete_barcode
  end

  def barcode_ean8_is_invalid?(barcode)
    return !EAN8.new(barcode).valid?
  end
end