class CreateAnalytics < ActiveRecord::Migration
  def change
    create_table :analytics do |t|
      t.integer :unique_hits
      t.integer :total_hits

      t.timestamps
    end
  end
end
