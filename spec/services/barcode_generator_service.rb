require 'rails_helper'

RSpec.describe 'Barcode generator service' do
  context "instance methods" do
    it 'generates random number of valid barcodes starting at lowest valid' do
      Barcode.destroy_all
      BarcodeGeneratorService.new.generate
      expect(Barcode.all.count).to include("00000017")
    end
  end

end
