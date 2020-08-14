require 'test_helper'

class BarcodeTest < ActiveSupport::TestCase

  test "should not save with empty barcode" do
    barcode = Barcode.create(barcode: nil, source: "test")
    assert_not barcode.save
  end

  test "should not save with nil barcode" do
    barcode = Barcode.create(barcode: nil, source: "test")
    assert_not barcode.save
  end

  test "should save with valid EAN8 barcode" do
    barcode = Barcode.create(barcode: EAN8.complete('1'.to_s.rjust(7, '0')), source: "test")
    assert barcode.save
  end

  test "should not save with invalid EAN8 barcode" do
    barcode = Barcode.create(barcode: "12345678", source: "test")
    assert_not barcode.save
    barcode = Barcode.create(barcode: "123", source: "test")
    assert_not barcode.save
    barcode = Barcode.create(barcode: "5678", source: "test")
    assert_not barcode.save
    barcode = Barcode.create(barcode: "45", source: "test")
    assert_not barcode.save
  end

  test "should enforce uniqueness" do
    barcode = Barcode.create(barcode: EAN8.complete('1'.to_s.rjust(7, '0')), source: "test")
    assert barcode.save
    barcode = Barcode.create(barcode: EAN8.complete('1'.to_s.rjust(7, '0')), source: "test")
    assert_not barcode.save
  end
  
end
