class AddFieldsToPostFollow < ActiveRecord::Migration
  def change
    add_reference :post_follows, :user, index: true, foreign_key: true, required: true
    add_reference :post_follows, :post, index: true, foreign_key: true, required: true
    add_column :post_follows, :activated, :boolean, required: true
  end
end
