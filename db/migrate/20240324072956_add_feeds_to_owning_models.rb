class AddFeedsToOwningModels < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :feed_id, :bigint
    add_column :groups, :feed_id, :bigint

    add_column :anime, :feed_id, :bigint
    add_column :manga, :feed_id, :bigint
    add_column :dramas, :feed_id, :bigint

    add_column :episodes, :feed_id, :bigint
    add_column :chapters, :feed_id, :bigint
  end
end
