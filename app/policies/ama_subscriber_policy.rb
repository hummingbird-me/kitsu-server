class AMASubscriberPolicy < ApplicationPolicy
  def create?
    record.user == user
  end
  alias_method :destroy?, :create?

  def update?
    false
  end
end
