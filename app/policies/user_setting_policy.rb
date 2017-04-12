class UserSettingsPolicy < ApplicationPolicy
  def create?
    is_owner?
  end
  alias_method :create?, :update?
  alias_method :destroy?, :update?
end
