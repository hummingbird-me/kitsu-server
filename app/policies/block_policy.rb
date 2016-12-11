class BlockPolicy < ApplicationPolicy
  def create?
    record.user == user
  end
  alias_method :destroy?, :create?
end
