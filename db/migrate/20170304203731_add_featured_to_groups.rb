class AddFeaturedToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :featured, :boolean, null: false, default: false
  end
end
