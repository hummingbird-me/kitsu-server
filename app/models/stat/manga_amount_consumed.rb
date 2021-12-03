class Stat < ApplicationRecord
  class MangaAmountConsumed < Stat
    include Stat::AmountConsumed

    def media_kind
      :manga
    end

    def unit_kind
      :chapter
    end

    def global_stat
      @global_stat ||= GlobalStat::MangaAmountConsumed.first
    end
  end
end
