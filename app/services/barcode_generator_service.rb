class BarcodeGeneratorService
  # This is just an example service. Please implement me.
  # Feel free to create more services as needed.
  def self.call()
    barcodes = []
    rnum = rand(0..99)
    count = 0
    seed = 0
    while count < rnum
      barcode = Barcode.create(barcode: EAN8.complete(seed.to_s.rjust(7, '0')), source: 'generated')
      if barcode.save
        count+=1
      end
      seed+=1
    end
    return count
  end
end
