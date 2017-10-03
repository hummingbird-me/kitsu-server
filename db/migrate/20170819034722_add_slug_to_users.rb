class AddSlugToUsers < ActiveRecord::Migration
  def change
    enable_extension 'citext'
    add_column :users, :slug, :citext
  end
end
