class MediaIgnorePolicy < ApplicationPolicy
  def update?
    false
  end

  def create?
    is_owner?
  end
  alias_method :destroy?, :create?
end
