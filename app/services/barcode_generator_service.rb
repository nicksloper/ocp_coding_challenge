class BarcodeGeneratorService

  def generate
    number_to_generate = rand(1..100)
    start = "0000001"
    codes = create_valid_codes(number_to_generate, start, [])
    BarcodeBulkCreatorService.new.create_codes(codes, "generator")
  end

  def create_valid_codes(number_to_generate, start, codes)
    until codes.length == number_to_generate
      code = EAN8.complete(start)
      if Barcode.where(code: code).blank?
        codes << code
      end
      start = "%07d" % (start.to_i + 1).to_s
    end
    codes
  end

end
