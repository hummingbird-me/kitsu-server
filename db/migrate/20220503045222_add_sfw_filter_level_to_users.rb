class AddSfwFilterLevelToUsers < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def up
    add_column :users, :sfw_filter_preference, :integer

    # 0 = SFW
    # 1 = NSFW (in NSFW places)
    # 2 = NSFW (everywhere)
    User.in_batches(of: 5000).update_all('sfw_filter_preference = (NOT sfw_filter)::integer')

    change_column_null :users, :sfw_filter_preference, false, 0
  end

  def down
    remove_column :users, :sfw_filter_preference
  end
end
