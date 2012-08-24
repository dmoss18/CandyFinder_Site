class RenameLongToLonInLocations < ActiveRecord::Migration
  def up
    rename_column(:locations, :long, :lon)
  end

  def down
  end
end
