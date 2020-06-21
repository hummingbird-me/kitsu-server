class Types::ProfileStats::CategoryBreakdown < Types::BaseObject
  description 'Generic Category Breakdown based on Media'

  field :total, Integer,
    null: false,
    description: 'The total amount of library entries.'

  def total
    object['total']
  end

  field :categories, Types::Map,
    null: false,
    description:
      <<~DESCRIPTION.squish
        A Dictionary of category_id -> count for all categories
        present on the library entries
      DESCRIPTION

  def categories
    object['categories']
  end
end
