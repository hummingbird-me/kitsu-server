class Types::ProfileStats::MangaCategoryBreakdown < Types::BaseObject
  implements Types::ProfileStats::ProfileStatInterface

  field :data, Types::ProfileStats::CategoryBreakdown,
    null: false,
    description: 'The breakdown of this specific stat.',
    method: :stats_data
end
