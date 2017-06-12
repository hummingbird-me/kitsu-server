class AddReEngagementColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :never_signed_in_email_sent, :boolean,
      default: false, null: false
    add_column :users, :first_inactive_email_sent, :boolean,
      default: false, null: false
    add_column :users, :second_inactive_email_sent, :boolean,
      default: false, null: false
    add_column :users, :third_inactive_email_sent, :boolean,
      default: false, null: false
  end
end
