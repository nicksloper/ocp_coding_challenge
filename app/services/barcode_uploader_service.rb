class BarcodeUploaderService

  attr_reader :count, :errors

  def initialize(workbook)
    @workbook = workbook
    @count = 0
    @errors = {}
  end

  def call()
    worksheets = @workbook.worksheets
    ActiveRecord::Base.transaction do
      worksheets.each do |worksheet|
        worksheet.each_with_index do |row, i|
          next if i == 0 || row[0].nil? # skips first row and empty rows
          barcode = row[0].value.to_s
          validatedResponse = BarcodeValidateService.call(barcode)
          if validatedResponse[:valid] == true # only saves after validating barcode
            Barcode.create(barcode: validatedResponse[:barcode], source: 'excel').save!
            @count += 1
          else
            @errors[validatedResponse[:barcode]] = validatedResponse[:error] # adds barcode and error message
          end
        end
      end
      @count = 0 if @errors.any? # count is 0 if any errors are encountered
      raise ActiveRecord::Rollback if @errors.any? # rollbacks transaction if errors are encountered
    end
    self
  end

end