class OneSignalPlayerPolicy < ApplicationPolicy
  alias_method :create?, :is_owner?
  alias_method :update?, :is_owner?
  alias_method :destroy?, :is_owner?

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
