class RemoveContentFormattedFromTicketMessages < ActiveRecord::Migration[4.2]
  def change
    remove_column :group_ticket_messages, :content_formatted, :text
  end
end
