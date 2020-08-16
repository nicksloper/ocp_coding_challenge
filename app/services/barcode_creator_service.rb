class BarcodeCreatorService

  def create_codes(valid_codes)
      valid_codes.each do |code|
        Barcode.create(code: code, source: "excel")
      end
  end

end
