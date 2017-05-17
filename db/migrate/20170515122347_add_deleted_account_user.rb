class AddDeletedAccountUser < ActiveRecord::Migration
  def up
    add_column :users, :deleted_at, :datetime

    # TODO: once we get unregistered accounts, switch it to one of those
    User.by_name('deleted').update_all(name: "deleted_#{SecureRandom.hex(1)}")
    User.create!(
      name: 'Deleted',
      id: -10,
      email: 'noreply+deleted@kitsu.io',
      password: SecureRandom.base64(45)
    )
  end

  def down
    remove_column :users, :deleted_at
    User.find(-10).destroy!
  end
end
