class MediaReactionVotePolicy < ApplicationPolicy
  def create?
    return false unless user
    return false if user.has_role?(:banned)

    is_owner?
  end
  alias_method :destroy?, :create?

  def update?
    false
  end
end
