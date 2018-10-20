class AddQuotesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :quotes_count, :integer, null: false, default: 0
  end
end
