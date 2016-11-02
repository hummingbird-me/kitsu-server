class FollowPolicy < ApplicationPolicy
  def update?
    false
  end

  def create?
    record.follower == user
  end
  alias_method :destroy?, :create?
end
