class BarcodesController < ApplicationController

  before_action :find_barcode, only: [:destroy]

  def upload
    begin
      workbook = RubyXL::Parser.parse(params['excel'].tempfile)
    rescue Zip::Error # Invalid file
      flash[:alert] = "Invalid file type. Must be .xlsx"
      return redirect_to action: 'import'
    rescue NoMethodError # Empty file
      flash[:alert] = "File is empty."
      return redirect_to action: 'import'
    end

    response = BarcodeUploaderService.call(workbook)

    if response[:count] > 0 # Valid barcodes imported.
      flash[:notice] = "#{response[:count].to_s} barcodes imported!"
      return redirect_to :root
    else # Invalid barcodes found
      flash[:alert] = "Invalid barcodes found: "
      response[:errors].each do |barcode, error| # Each barcode and associated error message displayed
        flash[:alert] += barcode + error
      end
      return redirect_to action: 'import'
    end
  end

  def generate
    barcode_count = BarcodeGeneratorService.call
    flash[:notice] = "Generated #{barcode_count.to_s} barcodes."
    redirect_to :barcodes
  end

  def destroy_all
    Barcode.destroy_all
    redirect_to :barcodes
  end

  def destroy
    code = @barcode.destroy!
    redirect_to :barcodes, notice: "Barcode #{code.barcode} deleted!"
  end

  protected

  def find_barcode
    @barcode = Barcode.find(params[:id])
  end

end
