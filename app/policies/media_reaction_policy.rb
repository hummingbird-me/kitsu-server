class MediaReactionPolicy < ApplicationPolicy
  def create?
    record.user == user
  end

  def update?
    false
  end

  def destroy?
    record.try(:user) == user || is_admin?
  end
end
