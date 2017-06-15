class MediaReactionPolicy < ApplicationPolicy
  def create?
    record.user == user
  end
  alias_method :update?, :create?

  def destroy?
    record.try(:user) == user || is_admin?
  end
end
