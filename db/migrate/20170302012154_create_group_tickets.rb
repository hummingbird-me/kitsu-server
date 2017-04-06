class CreateGroupTickets < ActiveRecord::Migration
  def change
    create_table :group_tickets do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.references :group, foreign_key: true, index: true, null: false
      t.references :assignee, index: true
      t.foreign_key :users, column: 'assignee_id'
      t.integer :status, default: 0, null: false, index: true
      t.timestamps null: false
    end
    create_table :group_ticket_messages do |t|
      t.references :ticket, index: true, null: false
      t.foreign_key :group_tickets, column: 'ticket_id'
      t.references :user, null: false
      t.integer :kind, default: 0, null: false
      t.text :content, null: false
      t.text :content_formatted, null: false
      t.timestamps null: false
    end
  end
end
