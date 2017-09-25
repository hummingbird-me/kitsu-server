class UploadPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    user ? true : false
  end

  alias_method :update?, :is_owner?
  alias_method :destroy?, :is_owner?

  class Scope < Scope
    def resolve
      scope
    end
  end
end
