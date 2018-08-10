class CharacterPolicy < ApplicationPolicy
  class AlgoliaScope < AlgoliaScope
    def resolve
      ""
    end
  end
end
