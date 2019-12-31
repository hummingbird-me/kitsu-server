class CreatePostFollows < ActiveRecord::Migration[4.2]
  def change
    create_table :post_follows do |t|

      t.timestamps null: false
    end
  end
end
