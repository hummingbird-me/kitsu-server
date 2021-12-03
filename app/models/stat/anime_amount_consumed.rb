class Stat < ApplicationRecord
  class AnimeAmountConsumed < Stat
    include Stat::AmountConsumed

    def media_kind
      :anime
    end

    def unit_kind
      :episode
    end

    def global_stat
      @global_stat ||= GlobalStat::AnimeAmountConsumed.first
    end
  end
end
