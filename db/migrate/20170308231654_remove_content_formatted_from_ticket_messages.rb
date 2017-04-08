class RemoveContentFormattedFromTicketMessages < ActiveRecord::Migration
  def change
    remove_column :group_ticket_messages, :content_formatted, :text
  end
end
