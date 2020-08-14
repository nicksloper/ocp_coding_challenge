class BarcodesController < ApplicationController
  before_action :file_check, only: [:create]

  def index
    @barcodes = Barcode.all
  end

  def new
    @barcode ||= Barcode.new
  end

  def import
=begin
  just now thinking of this but i could have created a file model.
  that would have helped my error issues.
  Also for sematic sake a File is not a Barcode.
=end
    @file ||= Barcode.new
  end

  def generate
    num = BarcodeGeneratorService.generate
    redirect_to root_path, notice:  "#{num} barcodes generated"
  end

  def create
    if params[:commit] == "Import Barcodes"
      import=ExcelParserService.parse(file_params[:file].path)
      res=Barcode.bulk_format(import)
      if res[:status]
        Barcode.create(res[:value])
        redirect_to root_path, notice: "#{res[:value].length} barcodes imported!"
      else
        redirect_to import_barcodes_path,
        alert: res[:value]
      end
    else
      # standard form input here if creating that view
    end
  end

  def update
  end

  private

  def file_params
    params.require(:barcode).permit(:file)
  end

  def file_check
=begin
  This check method works. The manual addtion of an error is a little hacky.
Probably should have been done in the model.
edit: addtion of error not showing up in view, needs revisiting
=end
    if params[:barcode] &&
      params[:barcode][:file] &&
      ["xlsx","xls","xlsm","xlsb"].include?(params[:barcode][:file].original_filename.split(".").last.downcase)
    else
      @file ||= Barcode.new
      @file.errors.messages[:import_error] = ["File missing or incorrect format"]
      redirect_to import_barcodes_path, alert: "File missing or incorrect format"
    end
  end
end
