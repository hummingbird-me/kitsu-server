class AddFirstMessageToTickets < ActiveRecord::Migration[4.2]
  def change
    add_reference :group_tickets, :first_message
    add_foreign_key :group_tickets, :group_ticket_messages,
      column: 'first_message_id'
  end
end
