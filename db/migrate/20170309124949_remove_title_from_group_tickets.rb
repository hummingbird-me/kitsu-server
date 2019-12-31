class RemoveTitleFromGroupTickets < ActiveRecord::Migration[4.2]
  def change
    remove_column :group_tickets, :title, :string
  end
end
