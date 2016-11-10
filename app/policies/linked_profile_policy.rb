class LinkedProfilePolicy < ApplicationPolicy
  def update?
    record.user == user || is_admin?
  end
  alias_method :create?, :update?
  alias_method :destroy?, :update?

  class Scope < Scope
    def resolve

    end
  end
end
