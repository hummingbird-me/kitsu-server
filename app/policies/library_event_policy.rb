class LibraryEventPolicy < ApplicationPolicy
  def create?
    false
  end
  alias_method :update?, :create?
end
