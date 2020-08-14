class CreateBarcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :barcodes do |t|
      t.string :source
      t.string :ean8, unique: true

      t.timestamps
    end
  end
end
