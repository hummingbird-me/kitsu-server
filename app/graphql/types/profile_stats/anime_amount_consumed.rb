class Types::ProfileStats::AnimeAmountConsumed < Types::BaseObject
  implements Types::Interface::ProfileStats::AmountConsumed

  field :time, Integer,
    null: false,
    description: 'Total time spent in minutes.'

  def time
    object.stats_data['time']
  end
end
