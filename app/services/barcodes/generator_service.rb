class Barcodes::GeneratorService < ServiceObject
  def execute
    generate_barcodes
    return success_message
  end

  private

  def initialize_attributes(options)
    @barcode_seed = 0 # Used as the base integer for generating new barcodes
    @valid_codes = []
  end

  def generate_barcodes
    for i in 1..barcode_count
      @valid_codes << get_valid_code
    end

    create_barcodes
  end

  def barcode_count
    return @barcode_count ||= rand(100)+1 # Generating between 1-100 barcodes
  end

  def get_valid_code
    code = generate_new_code
    while(!barcode_is_valid?(code))
      code = generate_new_code
    end

    return code
  end

  def generate_new_code
    @barcode_seed = @barcode_seed+1
    code = @barcode_seed.to_s.rjust(7, '0')
    code = EAN8.complete(code)

    return code
  end

  def barcode_is_valid?(code)
    return Barcodes::ValidatorService.execute(barcode: code)
  end

  def create_barcodes
    Barcodes::CreateFromGeneratorService.execute(barcodes: @valid_codes)
  end

  def success_message
    return "#{barcode_count} #{barcode_count > 1 ? 'barcodes' : 'barcode'} generated"
  end
end