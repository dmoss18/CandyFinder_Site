class AddGooglePlacesFieldsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :ext_id, :string
    add_column :locations, :ext_reference, :string
    add_column :locations, :phone_international, :string
    add_column :locations, :phone_formatted, :string
    add_column :locations, :ext_url, :string
  end
end
