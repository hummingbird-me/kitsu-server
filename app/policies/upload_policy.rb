class UploadPolicy < ApplicationPolicy
  administrated_by :community_mod

  def show?
    true
  end

  def create?
    user ? true : false
  end

  def update?
    is_owner?
  end

  def destroy?
    is_owner? || can_administrate?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
