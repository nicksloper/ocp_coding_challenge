require 'test_helper'

class BarcodeGeneratorServiceTest < ActiveSupport::TestCase

  test "should generate random number of barcodes between 1 and 100" do
    barcode_count = BarcodeGeneratorService.call
    assert Barcode.all.size == barcode_count
  end
  
end