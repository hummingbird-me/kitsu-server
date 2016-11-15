class ListImportPolicy < ApplicationPolicy
  def create?
    record.user == user || is_admin?
  end

  def update?
    false
  end
  alias_method :destroy, :update?

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
