class AddIpsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :ip_addresses, :inet, array: true, default: []
    execute <<~SQL.squish
      UPDATE users
      SET ip_addresses = ARRAY[current_sign_in_ip::inet, last_sign_in_ip::inet]
    SQL
    remove_column :users, :last_sign_in_ip
    remove_column :users, :current_sign_in_ip
  end
end
