class AddAliasAndDescriptionToCandy < ActiveRecord::Migration
  def change
    add_column :candies, :description, :string
    add_column :candies, :alias, :string
  end
end
