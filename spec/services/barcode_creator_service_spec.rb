require 'rails_helper'

RSpec.describe 'Barcode creator service' do
  it 'creates a batch of Barcodes in the database' do
    Barcode.destroy_all
    service = BarcodeBulkCreatorService.new
    codes = ["00000017", "00000024"]
    service.create_codes(codes, "excel")
    expect(Barcode.count).to eq(2)
  end
end
