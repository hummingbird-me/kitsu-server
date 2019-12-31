class AddFieldsToPostFollow < ActiveRecord::Migration[4.2]
  def change
    add_reference :post_follows, :user, index: true, foreign_key: true, required: true
    add_reference :post_follows, :post, index: true, foreign_key: true, required: true
  end
end
