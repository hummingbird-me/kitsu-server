class AddTaglineToGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :groups, :tagline, :string, limit: 60
  end
end
