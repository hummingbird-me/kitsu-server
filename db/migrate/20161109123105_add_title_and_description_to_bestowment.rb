class AddTitleAndDescriptionToBestowment < ActiveRecord::Migration
  def change
    add_column :bestowments, :title, :string
    add_column :bestowments, :description, :text
  end
end
