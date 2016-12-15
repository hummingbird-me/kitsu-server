class QuoteLikePolicy < ApplicationPolicy
  def update?
    false
  end

  def create?
    record.user == user
  end
  alias_method :destroy?, :create?
end
