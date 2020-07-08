module Types::Interface::ProfileStats::CategoryBreakdown
  include Types::Interface::ProfileStats::Base
  description 'Generic Category Breakdown based on Media'

  field :total, Integer,
    null: false,
    description: 'The total amount of library entries.'

  def total
    object.stats_data['total']
  end

  field :categories, Types::Map,
    null: false,
    description:
      <<~DESCRIPTION.squish
        A Dictionary of category_id -> count for all categories
        present on the library entries
      DESCRIPTION

  def categories
    object.stats_data['categories']
  end
end
