require 'test_helper'

class BarcodePadServiceTest < ActiveSupport::TestCase

  test "should left pad 8 digits" do
    barcode = BarcodePadService.call '00031'
    assert barcode == '00000031'
    assert EAN8.new(barcode).valid?
  end

  test "should pad and checksum" do
    barcode = BarcodePadService.call '9'
    assert barcode == '00000093'
    assert EAN8.new(barcode).valid?
  end

  test "should return nil for barcode over 8 digits or with incorrect check sum" do
    barcode = BarcodePadService.call '123456789'
    assert barcode.nil?
    barcode = BarcodePadService.call '12345678'
    assert barcode.nil?
  end
  
end