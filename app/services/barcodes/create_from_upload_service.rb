class Barcodes::CreateFromUploadService < Barcodes::CreationService
  private

  def source
    return @source ||= 'excel'
  end
end