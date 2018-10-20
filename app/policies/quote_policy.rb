class QuotePolicy < ApplicationPolicy
  def update?
    is_owner? && is_admin?
  end
  alias_method :create?, :update?
  alias_method :destroy?, :update?
end
