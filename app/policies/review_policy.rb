class ReviewPolicy < ApplicationPolicy
  alias_method :create?, :is_owner?

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
