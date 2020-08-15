require 'rails_helper'

RSpec.describe Barcodes::CreationService do
  context '.execute' do
    it 'creates barcodes with creation service source' do
      jim_barcode = double()
      dwight_barcode = double()
      jim_code = '00000055'
      dwight_code = '00001335'

      Barcode.stub(:new).with(code: jim_code, source: 'creation service') {jim_barcode}
      Barcode.stub(:new).with(code: dwight_code, source: 'creation service') {dwight_barcode}

      jim_barcode.stub(:save) {true}
      dwight_barcode.stub(:save) {true}

      expect(Barcodes::CreationService.execute(barcodes: [jim_code, dwight_code])).to eq(2)
    end

    it 'creates barcodes with source passed as argument' do
      jim_barcode = double()
      dwight_barcode = double()
      jim_code = '00000055'
      dwight_code = '00001335'

      Barcode.stub(:new).with(code: jim_code, source: 'dunder mifflin') {jim_barcode}
      Barcode.stub(:new).with(code: dwight_code, source: 'dunder mifflin') {dwight_barcode}

      jim_barcode.stub(:save) {true}
      dwight_barcode.stub(:save) {false}

      expect(Barcodes::CreationService.execute(barcodes: [jim_code, dwight_code], source: 'dunder mifflin')).to eq(1)
    end
  end
end
