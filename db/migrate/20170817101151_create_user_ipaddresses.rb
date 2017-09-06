class CreateUserIpaddresses < ActiveRecord::Migration
  def change
    create_table :user_ip_addresses do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.inet :ip_address, null: false
      t.index %i[ip_address user_id], unique: true
      t.timestamps null: false
    end
  end
end
