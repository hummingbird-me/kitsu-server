class LibraryEntryPolicy < ApplicationPolicy
  alias_method :update?, :is_owner?
  alias_method :create?, :is_owner?
  alias_method :destroy?, :is_owner?

  class Scope < Scope
    def resolve
      scope.visible_for(user)
    end
  end
end
