class BarcodeValidatorService

  def validate(file)
    worksheet = RubyXL::Parser.parse(file)[0]
    @codes = { :valid_codes => [], :invalid_codes => [] }
    worksheet.drop(1).each.with_index do |row, i|
        code = row[0].value.to_s
        check_length(code) if !code.empty?
    end
    @codes
  end

private

  def check_length(code)
    if code.length > 8 || repeat?(code)
      @codes[:invalid_codes] << code
    elsif code.length < 8
      code = "%07d" % code
      check_ean(code, true)
    else
      check_ean(code, false)
    end
  end

  def repeat?(code)
    @codes[:valid_codes].include?(code) || !Barcode.where(code: code).blank?
  end

  def check_ean(code, padded)
    if EAN8.valid?(code)
      @codes[:valid_codes] << code
    elsif padded == true
      @codes[:valid_codes] << EAN8.complete(code)
    else
      @codes[:invalid_codes] << code
    end
  end


end
