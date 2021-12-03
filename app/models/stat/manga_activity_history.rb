class Stat < ApplicationRecord
  class MangaActivityHistory < Stat
    include Stat::ActivityHistory

    def media_kind
      :manga
    end
  end
end
