class BarcodesController < ApplicationController

  def import
    # file = params["excelFile"]
    file = './doc/task1_barcodes.xlsx'
    worksheet = RubyXL::Parser.parse(file)[0]
    created_count = 0
    worksheet.drop(1).each.with_index do |row, i|
      if row[0].value != nil
        Barcode.create(code: row[0].value, source: "excel")
        created_count += 1
      end
      require "pry"; binding.pry
    end
    # print how many barcodes where created
    redirect_to :root, notice: "#{created_count} Barcodes created!"
  end


end
