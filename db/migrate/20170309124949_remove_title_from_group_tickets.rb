class RemoveTitleFromGroupTickets < ActiveRecord::Migration
  def change
    remove_column :group_tickets, :title, :string
  end
end
