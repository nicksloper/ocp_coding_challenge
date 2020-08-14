class Barcode < ActiveRecord::Base

  validates :ean8, :source, presence: true
  validates :ean8, uniqueness: true
  default_scope {order(ean8: :asc)}
=begin
I wanted to put a "vaildates" here for EAN8.
it would require some refactoring for the bulk import but it
would be useful.
=end

  # def file
  # end

  def self.barcode_formated? barcode
    EAN8.valid?(barcode)
  end

  def barcode_valid?
    EAN8.valid?(ean8)
  end

  def self.format_or_fail barcode
    # returns a vaild ean8 or false

=begin
  This took a couple trys to work out. Started with a loop with if/else but
that quickly became unruly. So i decided to let "bulk" do the loop and
return good codes.
=end

    return false if barcode.length > 8
    b = barcode.rjust(8,'0')
    return b if EAN8.valid?(b)
    b = EAN8.complete(barcode.rjust(7,'0'))
    return b if EAN8.valid?(b)
    false
  end

  def self.bulk_format barcodes
    # takes an array of barcode objects => [{ean8: , source: }, ...]

=begin
  I dont like the "new_barcode != false" check but it is a result of my above descion
to return good codes or false. I could have run a format method and then a vaild check
inorder to get to "if new_barcode.valid?" or do an "unless" check. on second thought i
might switch this to an unless.
=end
    good = []
    bad = []
    barcodes.each do |b|
      new_barcode = format_or_fail(b[:ean8])
      unless new_barcode
        bad.push(b[:ean8]) if b[:ean8] != nil
      else
        good.push({ean8: new_barcode, source: b[:source]})
      end
    end
    bad.length == 0 ? {status: true, value: good } : {status: false, value: "Invalid barcodes found: #{bad.join(",")}."}
  end
end
