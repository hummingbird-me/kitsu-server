class CreateAmaSubscribers < ActiveRecord::Migration
  def change
    create_table :ama_subscribers do |t|
      t.references :ama, foreign_key: true, index: true, null: false
      t.references :user, foreign_key: true, index: true, null: false
      t.timestamps null: false
    end
  end
end
