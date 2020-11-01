class CategoryPolicy < ApplicationPolicy
  administrated_by :database_mod

  class Scope < Scope
    def resolve
      return scope if see_nsfw?
      scope.where(nsfw: false)
    end
  end
end
