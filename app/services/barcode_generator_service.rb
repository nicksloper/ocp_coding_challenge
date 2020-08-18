class BarcodeGeneratorService

  def generate
    number_to_generate = rand(1..100)
    start = "0000001"
    codes = []
    until codes.length == number_to_generate
      code = start.to_s + checksum(start).to_s
      if Barcode.where(code: code).blank?
        codes << code
      end
      start = "%07d" % (start.to_i + 1).to_s
    end
    BarcodeCreatorService.new.create_codes(codes, "generator")
  end

  def checksum(code)
    odd = (code[0].to_i + code[2].to_i + code[4].to_i + code[6].to_i) * 3
    even = code[1].to_i + code[3].to_i + code[5].to_i
    digit = 10 - (odd + even).to_s[-1].to_i
    digit = 0 if digit == 10
    digit
  end

end
