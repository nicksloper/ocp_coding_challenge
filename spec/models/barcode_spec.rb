require 'rails_helper'

RSpec.describe "Barcode", type: :model do

  it "requires a source value" do
    b = Barcode.new(ean8: "09876543")
    expect(b.valid?).to be false
  end

  it "requres a ean8 value" do
    b = Barcode.new(source:"Test")
    expect(b.valid?).to be false
  end

  it "can check barcode formats" do
    b = Barcode.new(source:"test", ean8: "00000000")
    expect(b.barcode_valid?).to be true

    b.ean8 = "00000001"
    expect(b.barcode_valid?).to be false
  end

  context "#format_or_fail" do
    code = "00000000"
    it "returns same EAN8 if valid " do
      expect(Barcode.format_or_fail(code)).to eq(code)
    end

    it "returns FALSE if ean8 is longer than 8" do
      code += "1"
      expect(Barcode.format_or_fail(code)).to be false
    end

    it "returns a valid ean8 after left padding to 8" do
      code = "017"
      expect(Barcode.format_or_fail(code)).to eq("00000017")
    end

    it "returns FALSE when given a invaild ean8" do
=begin
  that EAN8.complete method really limits invalid vaules
=end
      code = "12312312"
      expect(Barcode.format_or_fail(code)).to be false
    end

    it "returns a vaild ean8 after left padding 7 zeros" do
      code = "1"
      expect(Barcode.format_or_fail(code)).to eq("00000017")
    end
  end

  context "#Bulk Format" do
    barcodes = [{ean8: "00000000", source: "test"}, {ean8: "00000017", source: "test"}, {ean8: "00000024", source: "test"}]

    it "returns .status = TRUE if all are vaild" do
      result = Barcode.bulk_format(barcodes)
      expect(result[:status]).to be true
    end

    it "returns .vaule => Array if all vaild" do
      result = Barcode.bulk_format(barcodes)
      expect(result[:value]).to eq(barcodes)
    end

    it "returns .status = FALSE if any are in vaild" do
      result = Barcode.bulk_format(barcodes + [{ean8: "12312312", source: "test"}])
      expect(result[:status]).to be false
    end

    it "returns a invalid barcode message if invailds are found" do
      result = Barcode.bulk_format(barcodes + [{ean8: "12312312", source: "test"}])
      expect(result[:value]).to eq("Invalid barcodes found: 12312312.")
    end
  end
end