class BarcodesController < ApplicationController

  def index
    @barcodes = Barcode.order(:id)
  end

  def new
    @error = true if params["error"]
  end

  def import
    file = params["excelFile"]
    # file = './doc/task1_barcodes.xlsx'
    if file == "" || file[-4..-1] != ('xlsx' || 'xls')
      redirect_to '/barcodes/new?error=true', alert: "Please select an excel file to upload"
    elsif !File.exist?(file)
      redirect_to '/barcodes/new?error=true', alert: "#{file} not found"
    else
      read_file(file)
    end
  end

  def create
    codes = BarcodeGeneratorService.new.generate
    redirect_to :root, notice: "#{codes.length} Barcodes generated"
  end

private

  def read_file(file)
    codes = BarcodeValidatorService.new.validate(file)
    if codes[:invalid_codes].count > 0
      redirect_to new_barcode_path, alert: "Invalid barcodes found: #{codes[:invalid_codes].join(", ")}"
    else
      BarcodeBulkCreatorService.new.create_codes(codes[:valid_codes], "excel")
      redirect_to :root, notice: "#{codes[:valid_codes].count} Barcodes created!"
    end
  end

end
