class BarcodeValidatorService

  def validate(file)
    worksheet = RubyXL::Parser.parse(file)[0]
    @codes = { :valid_codes => [], :invalid_codes => [] }
    worksheet.drop(1).each.with_index do |row, i|
        code = row[0].value.to_s
        check_length(code)
    end
    @codes
  end

private

  def check_length(code)
    if code.length > 8 || repeat?(code)
      @codes[:invalid_codes] << code
    elsif code.length < 8
      code = "%08d" % code
      check_eid(code, true)
    else
      check_eid(code, false)
    end
  end

  def repeat?(code)
    @codes[:valid_codes].include?(code)
  end

  def check_eid(code, padded)
    if EAN8.valid?(code)
      @codes[:valid_codes] << code
    elsif padded == true
      check_digit = checksum(code[1..-1])
      code = code[1..-1] + check_digit.to_s
      @codes[:valid_codes] << code
    else
      @codes[:invalid_codes] << code
    end
  end

  def checksum(code)
    odd = (code[0].to_i + code[2].to_i + code[4].to_i + code[6].to_i) * 3
    even = code[1].to_i + code[3].to_i + code[5].to_i
    10 - (odd + even).to_s[-1].to_i
  end

end
