class BarcodeValidatorService

  def validate(file)
    worksheet = RubyXL::Parser.parse(file)[0]
    codes = { :valid_codes => [], :invalid_codes => [] }
    worksheet.drop(1).each.with_index do |row, i|
        code = row[0].value.to_s
        if EAN8.valid?(code) && !codes[:valid_codes].include?(code)
          codes[:valid_codes] << code
        else
          codes[:invalid_codes] << code if !code.empty?
        end
    end
    codes
  end

end
