class InsertExistingUserIpAddressAndRemoveColumnFromUsers < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    User.find_each do |user|
      ips = user.ip_addresses.map do |ip|
        {ip_address: ip, user_id: user.id}
      end
      UserIpAddress.create!(ips)
    end
    remove_column :users, :ip_addresses, :inet
  end
end
