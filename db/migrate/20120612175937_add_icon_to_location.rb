class AddIconToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :ext_image_url, :string
    add_column :locations, :local_image_url, :string
  end
end
