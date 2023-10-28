class AddDescriptionToVolumes < ActiveRecord::Migration[6.1]
  def change
    add_column :volumes, :description, :jsonb, default: {}, null: false
  end
end
