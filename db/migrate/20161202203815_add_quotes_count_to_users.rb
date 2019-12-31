class AddQuotesCountToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :quotes_count, :integer, null: false, default: 0
  end
end
