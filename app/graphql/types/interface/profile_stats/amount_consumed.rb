module Types::Interface::ProfileStats::AmountConsumed
  include Types::Interface::ProfileStats::Base
  description 'Generic Amount Consumed based on Media'

  field :media, Integer,
    null: false,
    description: 'Total amount of media.'

  def media
    object.stats_data['media']
  end

  field :units, Integer,
    null: false,
    description: 'Total progress of library including reconsuming.'

  def units
    object.stats_data['units']
  end

  field :completed, Integer,
    null: false,
    description: 'Total media completed atleast once.'

  def completed
    object.stats_data['completed']
  end
end
