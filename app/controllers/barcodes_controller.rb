class BarcodesController < ApplicationController

  def index
    @barcodes = Barcode.order(:id)
  end

  def new
    @error = true if params["error"]
  end

  def import
    # file = params["excelFile"]
    if params[:excelFile] == "" || params[:excelFile][-4..-1] != 'xlsx'
      redirect_to '/barcodes/new?error=true', alert: "Please select an excel file to upload"
    else
      file = './doc/task2_barcodes.xlsx'
      codes = BarcodeValidatorService.new.validate(file)
      if codes[:invalid_codes].count > 0
        redirect_to new_barcode_path, alert: "Invalid barcodes found: #{codes[:invalid_codes].join(", ")}"
      else
        BarcodeCreatorService.new.create_codes(codes[:valid_codes], "excel")
        redirect_to :root, notice: "#{codes[:valid_codes].count} Barcodes created!"
      end
    end
  end

  def generate
    codes = BarcodeGeneratorService.new.generate
    redirect_to :root, notice: "#{codes.length} Barcodes generated"
  end


end
