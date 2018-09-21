class GlobalStat < ApplicationRecord
  class MangaAmountConsumed < GlobalStat
    include GlobalStat::AmountConsumed

    def stat_class
      Stat::MangaAmountConsumed
    end
  end
end
