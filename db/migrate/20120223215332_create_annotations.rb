class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.integer :candy_id
      t.string :candy_sku
      t.string :device_id
      t.integer :location_id

      t.timestamps
    end
  end
end
