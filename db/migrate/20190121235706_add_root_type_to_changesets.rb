class AddRootTypeToChangesets < ActiveRecord::Migration
  def change
    add_column :changesets, :root_type, :string, null: false
  end
end
