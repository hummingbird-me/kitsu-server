class Types::ProfileStats::AnimeAmountConsumed < Types::BaseObject
  implements Types::ProfileStats::ProfileStatInterface

  field :data, Types::ProfileStats::AmountConsumed,
    null: false,
    description: 'The breakdown of this specific stat.',
    method: :stats_data
end
