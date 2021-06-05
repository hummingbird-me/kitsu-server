class AddSystemUser < ActiveRecord::Migration[5.2]
  class NonvalidatingUser < User
    def not_reserved_name; end
  end

  def change
    # TODO: once we get unregistered accounts, switch it to one of those
    NonvalidatingUser.create!(
      name: 'System',
      id: -11,
      email: 'noreply+system@kitsu.io',
      password: SecureRandom.base64(45)
    )
  end
end
