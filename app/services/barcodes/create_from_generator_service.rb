class Barcodes::CreateFromGeneratorService < Barcodes::CreationService
  private

  def source
    return @source ||= 'generator'
  end
end