class InsertExistingUserIpAddressAndRemoveColumnFromUsers < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    User.find_each do |user|
      all_users_notifications = []
      user.ip_addresses.each do |ip|
        all_users_notifications << {ip_address: ip, user: user}
      end
      UserIpaddress.create(all_users_notifications)
    end
    remove_column :users, :ip_addresses, :inet
  end
end
