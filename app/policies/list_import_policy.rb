class ListImportPolicy < ApplicationPolicy
  administrated_by :admin

  def create?
    record.user == user || can_administrate?
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
