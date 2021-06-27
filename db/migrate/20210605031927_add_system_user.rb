class AddSystemUser < ActiveRecord::Migration[5.2]
  def change
    # TODO: once we get unregistered accounts, switch it to one of those
    User.new(
      name: 'System',
      id: -11,
      email: 'noreply+system@kitsu.io',
      password: SecureRandom.base64(45)
    ).save!(validate: false)
  end
end
