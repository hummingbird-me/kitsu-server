class UploadPolicy < ApplicationPolicy
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
    is_owner? || is_admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
