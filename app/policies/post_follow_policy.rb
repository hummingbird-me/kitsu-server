class PostFollowPolicy < ApplicationPolicy
  def create?
    record.user == user
  end
  def update?
    record.user == user
  end
  alias_method :destroy?, :create?
end
