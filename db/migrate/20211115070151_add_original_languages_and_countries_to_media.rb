class AddOriginalLanguagesAndCountriesToMedia < ActiveRecord::Migration[6.0]
  def change
    add_column :anime, :origin_languages, :string, array: true, default: []
    add_column :anime, :origin_countries, :string, array: true, default: []
    add_column :manga, :origin_languages, :string, array: true, default: []
    add_column :manga, :origin_countries, :string, array: true, default: []
    add_column :dramas, :origin_languages, :string, array: true, default: []
    add_column :dramas, :origin_countries, :string, array: true, default: []
  end
end
