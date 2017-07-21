class FollowPolicy < ApplicationPolicy
  def update?
    false
  end

  def create?
    record.follower == user
  end
  alias_method :destroy?, :create?

  def visible_attributes(all)
    is_owner? ? all : all - %i[hidden]
  end
  alias_method :editable_attributes, :visible_attributes
end
