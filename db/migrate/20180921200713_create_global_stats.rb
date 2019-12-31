class CreateGlobalStats < ActiveRecord::Migration[4.2]
  def change
    create_table :global_stats do |t|
      t.string :type, null: false
      t.jsonb :stats_data, null: false, default: {}
      t.timestamps null: false
    end
  end
end
