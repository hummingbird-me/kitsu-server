class AddOriginalLocaleToMedia < ActiveRecord::Migration
  def change
    add_column :anime, :original_locale, :string
    add_column :manga, :original_locale, :string
  end
end
