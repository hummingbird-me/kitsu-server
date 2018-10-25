class Types::MutationType < Types::BaseObject
  field :ping, String,
    null: false,
    description: 'Fixes GraphQL; does nothing else.'

  def ping
    'pong'
  end
end
