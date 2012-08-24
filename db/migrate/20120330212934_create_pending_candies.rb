class CreatePendingCandies < ActiveRecord::Migration
  def change
    create_table :pending_candies do |t|
      t.string :title
      t.string :subtitle
      t.string :sku

      t.timestamps
    end
  end
end
