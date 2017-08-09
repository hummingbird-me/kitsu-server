class AnimePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user && !user.sfw_filter?
        scope
      else
        scope.sfw
      end
    end
  end

  class AlgoliaScope < AlgoliaScope
    def resolve
      if user && !user.sfw_filter?
        ''
      else
        'NOT ageRating:R18'
      end
    end
  end
end
