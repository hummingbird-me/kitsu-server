class CreateStories < ActiveRecord::Migration[6.1]
  def change
    create_table :stories, id: false do |t|
      # These columns are ordered to pack more efficiently
      t.bigint :id, primary_key: true, default: -> { 'generate_snowflake()' }
      t.timestamp :created_at, null: false
      t.timestamp :bumped_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.integer :type, null: false, limit: 2
      t.jsonb :data, null: false, default: {}
    end
  end
end
