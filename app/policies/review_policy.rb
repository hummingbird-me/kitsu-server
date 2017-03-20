class ReviewPolicy < ApplicationPolicy
  def create?
    user.registered? && is_owner?
  end

  def update?
    is_owner? || is_admin?
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
