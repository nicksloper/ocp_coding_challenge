class Barcodes::ParseBarcodesFromFileService < ServiceObject
  attr_reader :results, :worksheet

  def execute
    return barcodes_from_file
  end

  private

  def initialize_attributes(options)
    @results = options[:results]
    @worksheet = options[:worksheet]
  end

  def barcodes_from_file
    worksheet.each_with_index do |row, i|
      next if i == 0 # Skip headers

      barcode = row[0].value.to_s
      next if barcode.blank?

      barcode = pad_incomplete_barcode(barcode)
      filter_barcode(barcode)
    end

    return results
  end

  def pad_incomplete_barcode(barcode)
    return Barcodes::PadIncompleteBarcodeService.execute(barcode: barcode)
  end

  def filter_barcode(barcode)
    if barcode_is_valid?(barcode)
      results[:valid] << barcode
    else
      results[:invalid] << barcode
    end
  end

  def barcode_is_valid?(barcode)
    return Barcodes::ValidatorService.execute(barcode: barcode)
  end
end