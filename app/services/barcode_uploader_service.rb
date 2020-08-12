class BarcodeUploaderService

  def self.call(workbook)
    worksheets = workbook.worksheets
    response = {count: 0, errors: []}
    ActiveRecord::Base.transaction do
      worksheets.each do |worksheet|
        worksheet.each_with_index do |row, i|
          next if i == 0
          barcode = row[0].value.to_s
          if Barcode.create(barcode: barcode, source: 'excel').save
            response[:count] += 1
          else
            newBarcode = BarcodePadService.call(barcode)
            if Barcode.create(barcode: newBarcode, source: 'excel').save
              response[:count] += 1
            else
              response[:errors].push(barcode)
            end
          end
        end
      end
      response[:count] = 0 if response[:errors].any?
      raise ActiveRecord::Rollback if response[:errors].any?
    end
    response
  end

end

          # if EAN8.new(barcode).valid? && Barcode.where(barcode: barcode).empty?
          #   barcodeRecord = Barcode.create(barcode: barcode, source: 'excel')
          #   barcodeRecord.save!
          #   response[:count] += 1
          # else
          #   newBarcode = BarcodePadService.call(barcode)
          #   if EAN8.new(newBarcode).valid?
          #     barcodeRecord = Barcode.create(barcode: newBarcode, source: 'excel')
          #     response[:errors].push(newBarcode) unless barcodeRecord.save
          #     response[:count] += 1
          #   else
          #     response[:errors].push(newBarcode)
          #   end
          # end