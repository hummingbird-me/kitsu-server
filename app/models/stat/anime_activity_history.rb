class Stat < ApplicationRecord
  class AnimeActivityHistory < Stat
    include Stat::ActivityHistory

    def media_kind
      :anime
    end
  end
end
