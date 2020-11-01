class ReviewPolicy < ApplicationPolicy
  administrated_by :community_mod

  def create?
    user.registered? && is_owner?
  end

  def update?
    is_owner? || can_administrate?
  end

  alias_method :destroy?, :update?

  def editable_attributes(all)
    all - [:content_formatted]
  end

  class Scope < Scope
    def resolve
      scope.where.not(user_id: blocked_users)
    end
  end
end
