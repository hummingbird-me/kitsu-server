class FavoritePolicy < ApplicationPolicy
  def update?
    record.user == user
  end
  alias_method :create?, :update?
  alias_method :destroy?, :update?
end
