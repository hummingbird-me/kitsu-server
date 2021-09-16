class AddImageDataToPeopleAndCharacters < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :image_data, :jsonb
    add_column :characters, :image_data, :jsonb
  end
end
