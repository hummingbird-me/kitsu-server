class QuotePolicy < ApplicationPolicy
  def create?
    record.user == user
  end

  def update?
    record.user == user || is_admin?
  end
  alias_method :destroy?, :update?
end
