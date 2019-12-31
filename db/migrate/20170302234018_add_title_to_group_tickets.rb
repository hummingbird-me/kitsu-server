class AddTitleToGroupTickets < ActiveRecord::Migration[4.2]
  def change
    add_column :group_tickets, :title, :string, null: false
  end
end
