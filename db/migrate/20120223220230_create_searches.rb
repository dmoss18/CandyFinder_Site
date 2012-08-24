class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer :candy_id
      t.string :search_term
      t.string :device_id

      t.timestamps
    end
  end
end
