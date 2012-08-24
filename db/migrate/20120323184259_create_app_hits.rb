class CreateAppHits < ActiveRecord::Migration
  def change
    create_table :app_hits do |t|
      t.string :device_id

      t.timestamps
    end
  end
end
