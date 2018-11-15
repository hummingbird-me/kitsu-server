class AddIssuesToMappings < ActiveRecord::Migration
  def change
    add_column :mappings, :issue, :string
  end
end
