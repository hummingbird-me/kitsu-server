class ProfileLinkSitePolicy < ApplicationPolicy
  def update?
    false
  end
  alias_method :create?, :update?
  alias_method :destroy?, :update?
end
