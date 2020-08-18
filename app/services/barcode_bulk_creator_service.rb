class BarcodeBulkCreatorService

  def create_codes(valid_codes, source)
      valid_codes.each do |code|
        Barcode.create(code: code, source: source)
      end
  end

end
