class QuotePolicy < ApplicationPolicy
  alias_method :create?, :is_owner?

  def update?
    is_owner? || is_admin?
  end
  alias_method :destroy?, :update?
end
