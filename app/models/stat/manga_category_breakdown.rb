class Stat < ApplicationRecord
  class MangaCategoryBreakdown < Stat
    include Stat::CategoryBreakdown

    def media_kind
      :manga
    end
  end
end
