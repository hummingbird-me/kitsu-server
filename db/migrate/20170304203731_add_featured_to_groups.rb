class AddFeaturedToGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :groups, :featured, :boolean, null: false, default: false
  end
end
