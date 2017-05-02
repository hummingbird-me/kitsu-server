class PostFollowPolicy < ApplicationPolicy
  def create?
    record.user == user
  end

  def update?
    false
  end
  alias_method :destroy?, :create?
end

