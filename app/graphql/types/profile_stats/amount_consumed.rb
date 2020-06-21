class Types::ProfileStats::AmountConsumed < Types::BaseObject
  description 'Generic Amount Consumed based on Media'

  field :time, Integer,
    null: false,
    description: 'Total time spent in minutes.'

  def time
    object['time']
  end

  field :media, Integer,
    null: false,
    description: 'Total amount of media.'

  def media
    object['media']
  end

  field :units, Integer,
    null: false,
    description: 'Total progress per media including reconsuming.'

  def units
    object['units']
  end

  field :completed, Integer,
    null: false,
    description: 'Total media completed atleast once.'

  def completed
    object['completed']
  end
end
