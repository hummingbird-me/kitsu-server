module MaintainIpAddresses
  extend ActiveSupport::Concern

  def maintain_ip_addresses
    current_user.resource_owner.add_ip(request.remote_ip) if signed_in?
  end

  included do
    before_action :maintain_ip_addresses
  end
end
