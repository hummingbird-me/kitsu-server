class AddHiddenAtToUserContent < ActiveRecord::Migration[5.2]
  def change
    add_column :media_reactions, :hidden_at, :datetime
    add_column :posts, :hidden_at, :datetime
    add_column :comments, :hidden_at, :datetime
  end
end
