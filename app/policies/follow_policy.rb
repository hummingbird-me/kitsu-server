class FollowPolicy < ApplicationPolicy
  def create?
    record.follower == user
  end
  alias_method :update?, :create?
  alias_method :destroy?, :create?
end
