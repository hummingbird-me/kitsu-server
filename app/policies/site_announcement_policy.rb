class SiteAnnouncementPolicy < ApplicationPolicy
  def update?
    is_admin?
  end
  alias_method :create?, :update?
  alias_method :destroy?, :update?
end
