class CreatePostFollows < ActiveRecord::Migration
  def change
    create_table :post_follows do |t|

      t.timestamps null: false
    end
  end
end
