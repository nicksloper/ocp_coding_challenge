class BarcodesController < ApplicationController
  before_action :find_barcode, only: [:destroy]

  def upload
    begin
      workbook = RubyXL::Parser.parse(params['excel'].tempfile)
    rescue Zip::Error
      flash[:alert] = "Invalid file type. Must be .xlsx"
      return redirect_to action: 'import'
    rescue NoMethodError
      flash[:alert] = "File is empty."
      return redirect_to action: 'import'
    end
    response = BarcodeUploaderService.call(workbook)
    if response[:count] > 0
      flash[:notice] = response[:count].to_s + " barcodes imported!"
      redirect_to :root
    else
      flash[:alert] = "Invalid barcodes found: "
      response[:errors].each do |error|
        flash[:alert] += error.to_s + ", "
      end
      redirect_to action: 'import'
    end
  end

  def import
  end

  def generate
    barcode_count = BarcodeGeneratorService.call
    flash[:notice] = "Generated " + barcode_count.to_s + " barcodes."
    redirect_to action: 'index' 
  end

  def destroy_all
    Barcode.destroy_all
    redirect_to action: 'index' 
  end

  def destroy
    @barcode.destroy!
    redirect_to :barcodes, notice: "Barcode deleted!"
  end

  protected

  def find_barcode
    @barcode = Barcode.find(params[:id])
  end

end
