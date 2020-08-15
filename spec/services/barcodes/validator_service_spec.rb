require 'rails_helper'

RSpec.describe Barcodes::ValidatorService do
  context '.execute' do
    it 'returns true if barcode is valid' do
      barcode = '00000055'
      Barcode.stub(:exists?).with(code: barcode) {false}

      ean8 = double()
      ean8.stub(:valid?) {true}
      EAN8.stub(:new).with(barcode) {ean8}

      expect(Barcodes::ValidatorService.execute(barcode: barcode)).to eq(true)
    end

    it 'returns false if barcode is duplicate' do
      barcode = '00000055'
      Barcode.stub(:exists?).with(code: barcode) {true}

      expect(Barcodes::ValidatorService.execute(barcode: barcode)).to eq(false)
    end

    it 'returns false if barcode is not valid ean8' do
      barcode = '00000054'
      Barcode.stub(:exists?).with(code: barcode) {false}

      ean8 = double()
      ean8.stub(:valid?) {false}
      EAN8.stub(:new).with(barcode) {ean8}

      expect(Barcodes::ValidatorService.execute(barcode: barcode)).to eq(false)
    end

    it 'returns false if barcode is too long' do
      barcode = '000000543432311'
      Barcode.stub(:exists?).with(code: barcode) {false}

      ean8 = double()
      ean8.stub(:valid?) {true}
      EAN8.stub(:new).with(barcode) {ean8}

      expect(Barcodes::ValidatorService.execute(barcode: barcode)).to eq(false)
    end
  end
end
