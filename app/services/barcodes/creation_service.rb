class Barcodes::CreationService < ServiceObject
  attr_reader :barcodes

  def execute
    create_barcodes
  end

  private

  def initialize_attributes(options)
    @barcodes = options[:barcodes].uniq
    @source = options[:source] || source
  end

  def source
    return @source ||= 'creation service'
  end

  def create_barcodes
    ActiveRecord::Base.transaction do
      barcodes.each do |barcode|
        create_barcode(barcode)
      end
    end
  end

  def create_barcode(barcode)
    Barcode.create(code: barcode, source: source)
  end
end