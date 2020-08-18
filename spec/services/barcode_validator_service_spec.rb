require 'rails_helper'

RSpec.describe 'Barcode validator service' do
  context "instance methods" do
    it 'validates each incoming barcode from excel file' do
      Barcode.destroy_all
      file = './doc/task2_barcodes.xlsx'
      codes = BarcodeValidatorService.new.validate(file)
      expect(codes[:valid_codes].length).to eq(4)
      expect(codes[:invalid_codes].length).to eq(1)
      expect(codes[:invalid_codes]).to include("1234567")
    end
  end

end
