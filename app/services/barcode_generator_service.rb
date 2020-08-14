class BarcodeGeneratorService

  def self.call()
    rnum = rand(1..100)
    count = 0
    seed = 0 # used to start generation at lowest possbile
    while count < rnum
      barcode = Barcode.create(barcode: EAN8.complete(seed.to_s.rjust(7, '0')), source: 'generated')
      if barcode.save
        count+=1
      end
      seed+=1 # incremented regardless of successful save
    end
    return count
  end
  
end
