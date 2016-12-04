class ReportPolicy < ApplicationPolicy
  def create?
    record.user == user
  end

  def update?
    record.user == user || is_admin?(record.naughty)
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      if is_global_admin?
        scope
      elsif admin_scopes
        scope.where(naughty_type: admin_scopes)
      else
        scope.where(user: user)
      end
    end

    def admin_scopes
      if user
        user.roles.where(name: 'admin', resource_id: nil).pluck(:resource_type)
      end
    end

    def is_global_admin?
      user&.has_role?(:admin)
    end
  end
end
