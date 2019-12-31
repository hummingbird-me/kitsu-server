class AddUniquenessConstraintToUserSlugs < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :slug, unique: true
  end
end
