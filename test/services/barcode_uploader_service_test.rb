require 'test_helper'

class BarcodeUploaderServiceTest < ActiveSupport::TestCase

  test "should skip empty rows" do
    workbook = RubyXL::Parser.parse(file_path('test_empty_barcode.xlsx'))
    response = BarcodeUploaderService.new(workbook).call
    assert response.count == 2
    assert response.errors.empty?
    assert Barcode.where(barcode: '12345670').any? && Barcode.where(barcode: '00000079').any?
  end

  test "should left pad barcodes with less then 8 digits" do
    workbook = RubyXL::Parser.parse(file_path('test_left_pad_barcode.xlsx'))
    response = BarcodeUploaderService.new(workbook).call
    assert response.count == 1
    assert response.errors.empty?
    assert Barcode.where(barcode: '00000031').any?
  end

  test "should left pad barcodes with less then 8 digits and checksum" do
    workbook = RubyXL::Parser.parse(file_path('test_checksum_barcode.xlsx'))
    response = BarcodeUploaderService.new(workbook).call
    assert response.count == 1
    assert response.errors.empty?
    assert Barcode.where(barcode: '00000093').any?
  end

  test "should rollback barcodes if file contains duplicate or invalid checksum barcodes" do
    workbook = RubyXL::Parser.parse(file_path('test_invalid_barcode.xlsx'))
    response = BarcodeUploaderService.new(workbook).call
    assert response.count == 0
    assert response.errors['12345678'] && response.errors['00000079']
    assert Barcode.all.size == 0
  end

  test "should import valid barcodes" do
    workbook = RubyXL::Parser.parse(file_path('test_valid_barcode.xlsx'))
    response = BarcodeUploaderService.new(workbook).call
    assert response.count == 3
    assert response.errors.empty?
    assert Barcode.all.size == 3
    assert Barcode.where(barcode: '00000314').any? && Barcode.where(barcode: '00000079').any? && Barcode.where(barcode: '00000093').any?
  end

end