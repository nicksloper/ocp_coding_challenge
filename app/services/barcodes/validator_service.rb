class Barcodes::ValidatorService < ServiceObject
  attr_reader :barcode

  def execute
    return barcode_is_valid?
  end

  private

  def initialize_attributes(options)
    @barcode = options[:barcode]
  end

  def barcode_is_valid?
    return false if barcode_is_duplicate? || barcode_ean8_is_invalid? || barcode_is_too_long?
    return true
  end

  def barcode_is_duplicate?
    return Barcode.exists?(code: barcode)
  end

  def barcode_ean8_is_invalid?
    return !EAN8.new(barcode).valid?
  end

  def barcode_is_too_long?
    return barcode.length > 8
  end
end