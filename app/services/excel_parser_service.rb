class ExcelParserService

  def self.parse path
    #* Workbook = entire excel file
=begin
    This is a neat libary. Docs where very useful.
  Took some experimenting to find what i was looking for
  but overall pretty easy.
=end
    result = []
    worksheet = RubyXL::Parser.parse(path)[0] #<- a.k.a. sheet1
    worksheet.each_with_index do |row, i|
      break if row.nil?
      next if i == 0 #<- removes Column Names
      next if row[0].value == "" #<- skip blanks
      next if row[0].value == nil #<- skip blanks
      result.push({ean8: row[0].value.to_s, source: "excel"})
    end
    result
  end
end