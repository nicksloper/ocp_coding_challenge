class BarcodesController < ApplicationController
  def import
  end

  def upload
    begin
      file_path = params[:excel_file].tempfile
      workbook = RubyXL::Parser.parse(file_path)
    rescue ::Zip::Error # File is not of type .xlsx
      return redirect_to import_barcodes_path(file_error: true), alert: "Please upload a .xlsx file."
    rescue NoMethodError # No file was selected for upload
      return redirect_to import_barcodes_path(file_error: true), alert: "Please choose a file to upload."
    end

    results = {valid: [], invalid: []}
    workbook.each do |worksheet|
      results = Barcodes::ParseBarcodesFromFileService.execute(results: results, worksheet: worksheet)
    end

    if results[:invalid].empty?
      Barcodes::CreateFromUploadService.execute(barcodes: results[:valid])
      return redirect_to :root, notice: "#{results[:valid].count} barcodes imported!"
    else
      return redirect_to :import_barcodes, alert: "Invalid barcodes found: #{results[:invalid].join(', ')}"
    end
  end

  def generate
    persisted_barcode_count = Barcodes::GeneratorService.execute.to_i
    if persisted_barcode_count > 0
      return redirect_to :root, notice: "#{persisted_barcode_count} #{persisted_barcode_count > 1 ? 'barcodes' : 'barcode'} generated"
    else
      return redirect_to :import, alert: "There was an error generating barcodes."
    end
  end
end