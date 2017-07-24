class FollowPolicy < ApplicationPolicy
  def create?
    is_owner?
  end
  alias_method :update?, :create?
  alias_method :destroy?, :create?

  def visible_attributes(all)
    is_owner? ? all : all - %i[hidden]
  end
  alias_method :editable_attributes, :visible_attributes

  # Override to user follower instead of user
  def is_owner? # rubocop:disable Style/PredicateName
    return false unless user && record.follower_id == user.id
    return false if record.follower_id_was && record.follower_id_was != user.id
    true
  end
end
