class BarcodeUploaderService

  def self.call(workbook)
    worksheets = workbook.worksheets
    response = {count: 0, errors: {}} # returns the count of successfully imported barcodes and any associated error messages
    ActiveRecord::Base.transaction do
      worksheets.each do |worksheet|
        worksheet.each_with_index do |row, i|
          next if i == 0 || row[0].nil? # skips first row and empty rows
          barcode = row[0].value.to_s
          validatedResponse = BarcodeValidateService.call(barcode)
          if validatedResponse[:valid] == true # only saves after validating barcode
            Barcode.create(barcode: validatedResponse[:barcode], source: 'excel').save!
            response[:count] += 1
          else
            response[:errors][validatedResponse[:barcode]] = validatedResponse[:error] # adds barcode and error message
          end
        end
      end
      response[:count] = 0 if response[:errors].any? # count is 0 if any errors are encountered
      raise ActiveRecord::Rollback if response[:errors].any? # rollbacks transaction if errors are encountered
    end
    response
  end

end