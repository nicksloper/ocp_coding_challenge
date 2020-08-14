class BarcodeGeneratorService
  # This is just an example service. Please implement me.
  # Feel free to create more services as needed.

=begin
  I enjoyed creating this method. It is nested loops so not the most
effiecent but its effective. I did notice that because we are respecting the
"lowest" EAN8 the loop has to "fail" more and more before it starts creating making the user
wait longer and longer.

  I had an idea different idea on how to do this but decided to switch to more simple code.
The idea whent like this:
  ALL = Barcode.all.pluck(:ean8) => ["00000000",...]
  if ALL.includes?( EAN8.complete() )
    ALL.shift until that EAN8 index
    EAN8.complete()++
    then try again

  I was thinking if i was testing with hundreds of barcodes it would be ineffienct to
  loop the the entire collection to look for the dup EAN8 the further in the array it gets.
=end
  def self.generate
    num = rand(1..100)
    start = "0"
    total = 0
    num.times do |i|
      barcode = EAN8.complete(start.rjust(7,'0'))
      attempt = Barcode.new(ean8: barcode, source: "generator")
      until attempt.save do
        start = (start.to_i + 1).to_s
        barcode = EAN8.complete(start.rjust(7,'0'))
        attempt = Barcode.new(ean8: barcode, source: "generator")
      end
      total+=1
    end
    total
  end
end
