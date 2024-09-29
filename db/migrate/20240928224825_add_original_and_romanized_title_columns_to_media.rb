class AddOriginalAndRomanizedTitleColumnsToMedia < ActiveRecord::Migration[6.1]
  def change
    add_column :anime, :original_title, :string
    add_column :manga, :original_title, :string
    add_column :dramas, :original_title, :string
    add_column :anime, :romanized_title, :string
    add_column :manga, :romanized_title, :string
    add_column :dramas, :romanized_title, :string
  end
end
