class Types::ProfileStats::AmountConsumed < Types::BaseObject
  description ''

  field :time, Integer,
    null: false,
    description: ''

  def time
    object['time']
  end

  field :media, Integer,
    null: false,
    description: ''

  def media
    object['media']
  end

  field :units, Integer,
    null: false,
    description: ''

  def units
    object['units']
  end

  field :completed, Integer,
    null: false,
    description: ''

  def completed
    object['completed']
  end
end
