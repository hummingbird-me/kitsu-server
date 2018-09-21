class GlobalStat < ApplicationRecord
  class AnimeAmountConsumed < GlobalStat
    include GlobalStat::AmountConsumed

    def stat_class
      Stat::AnimeAmountConsumed
    end
  end
end
