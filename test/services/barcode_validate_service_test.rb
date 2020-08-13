require 'test_helper'

class BarcodeValidateServiceTest < ActiveSupport::TestCase

  test "should invalidate barcode larger than 8 digits" do
    barcode = '123456789'
    response = BarcodeValidateService.call(barcode)
    assert response[:valid] == false
    assert response[:barcode] == barcode
    assert response[:error] == ' is too large. '
  end

  test "should left pad 8 digits" do
    barcode = '00031'
    response = BarcodeValidateService.call(barcode)
    assert response[:valid] == true
    assert response[:barcode] == '00000031'
    assert response[:error] == nil
  end

  test "should pad and checksum" do
    barcode = '9'
    response = BarcodeValidateService.call(barcode)
    assert response[:valid] == true
    assert response[:barcode] == '00000093'
    assert response[:error] == nil
  end

  test "should invalidate barcode with incorrect checksum" do
    barcode = '12345678'
    response = BarcodeValidateService.call(barcode)
    assert response[:valid] == false
    assert response[:barcode] == barcode
    assert response[:error] == ' is not EAN8 compatible. '
  end

  test "should validate ean8 barcodes" do
    barcode = '12345670'
    response = BarcodeValidateService.call(barcode)
    assert response[:valid] == true
    assert response[:barcode] == barcode
    assert response[:error] == nil
  end

  test "should invalidate existing barcodes" do
    barcode = '12345670'
    Barcode.create(barcode: barcode, source: 'test').save!
    response = BarcodeValidateService.call(barcode)
    assert response[:valid] == false
    assert response[:barcode] == barcode
    assert response[:error] == ' already exists. '
    
    barcode = '9'
    completeBarcode = '00000093'
    Barcode.create(barcode: completeBarcode, source: 'test').save!
    response = BarcodeValidateService.call(barcode)
    assert response[:valid] == false
    assert response[:barcode] == barcode
    assert response[:error] == ' already exists. '
  end

end