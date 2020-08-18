require 'rails_helper'

RSpec.describe Barcode, type: :model do
  describe 'validations' do
    it { should validate_presence_of :code}
    it { should validate_presence_of :source}
  end
end
