class BarcodesController < ApplicationController

  def new
    @error = true if params["error"]
  end

  def import
    # file = params["excelFile"]
    if params[:excelFile] == "" || params[:excelFile][-4..-1] != 'xlsx'
      redirect_to '/barcodes/new?error=true', alert: "Please select an excel file to upload"
    else
    file = './doc/task1_barcodes.xlsx'
    worksheet = RubyXL::Parser.parse(file)[0]
    created_count = 0
      worksheet.drop(1).each.with_index do |row, i|
        if row[0].value != nil
          Barcode.create(code: row[0].value, source: "excel")
          created_count += 1
        end
      end
    redirect_to :root, notice: "#{created_count} Barcodes created!"
    end
    # print how many barcodes where created
  end

# check it each barcode in ean8 or a duplicate
#     - don't store anything in database and diplay error message
end
