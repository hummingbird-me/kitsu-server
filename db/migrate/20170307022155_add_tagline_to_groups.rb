class AddTaglineToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :tagline, :string, limit: 60
  end
end
