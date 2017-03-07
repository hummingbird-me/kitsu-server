class AddTitleToGroupTickets < ActiveRecord::Migration
  def change
    add_column :group_tickets, :title, :string, null: false
  end
end
