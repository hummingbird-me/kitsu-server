class NotificationSettingPolicy < ApplicationPolicy
  def create?
    false
  end
  alias_method :update?, :is_owner?
  alias_method :destroy?, :create?
end
