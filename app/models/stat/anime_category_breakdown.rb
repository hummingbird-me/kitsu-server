class Stat < ApplicationRecord
  class AnimeCategoryBreakdown < Stat
    include Stat::CategoryBreakdown

    def media_kind
      :anime
    end
  end
end
