# frozen_string_literal: true

module MaintainIPAddresses
  extend ActiveSupport::Concern

  def maintain_ip_addresses
    return unless signed_in? && current_user.resource_owner

    # RAILS-7: Replace this with UserIpAddress.upsert(update_only:)
    binds = [
      [nil, current_user.resource_owner.id],
      [nil, request.remote_ip],
      [nil, Time.current]
    ]
    UserIPAddress.connection.exec_update(<<~SQL.squish, 'SQL', binds)
      INSERT INTO user_ip_addresses (user_id, ip_address, created_at, updated_at)
        VALUES ($1, $2, $3, $3)
      ON CONFLICT (user_id, ip_address)
      DO UPDATE SET
        updated_at = excluded.updated_at,
        user_id = excluded.user_id,
        ip_address = excluded.ip_address
        WHERE updated_at < (now() - interval '6 hours')
    SQL
  end

  included do
    before_action :maintain_ip_addresses
  end
end
