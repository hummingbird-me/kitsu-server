class PostFollowPolicy < ApplicationPolicy
  def create?
    record.user == user
  end
  alias_method :destroy?, :create?

  def update?
    false
  end
end
