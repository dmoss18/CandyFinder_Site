class DeleteFullNameFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :full_name
  end

  def down
    remove_column :users, :full_name
  end
end
