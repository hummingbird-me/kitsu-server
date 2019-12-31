class AddOriginalLocaleToMedia < ActiveRecord::Migration[4.2]
  def change
    add_column :anime, :original_locale, :string
    add_column :manga, :original_locale, :string
  end
end
