class Barcodes::CreationService < ServiceObject
  attr_reader :barcodes

  def execute
    create_barcodes
    return @persisted_barcode_count
  end

  private

  def initialize_attributes(options)
    @barcodes = options[:barcodes].uniq
    @source = options[:source] || source
    @persisted_barcode_count = 0
  end

  def source
    return @source ||= 'creation service'
  end

  def create_barcodes
    ActiveRecord::Base.transaction do
      barcodes.each do |code|
        create_barcode(code)
      end
    end
  end

  def create_barcode(code)
    barcode = Barcode.new(code: code, source: source)
    if barcode.save
      @persisted_barcode_count += 1
    end
  end
end