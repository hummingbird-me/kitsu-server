class CharacterPolicy < ApplicationPolicy
  administrated_by :database_mod

  class AlgoliaScope < AlgoliaScope
    def resolve
      ""
    end
  end
end
