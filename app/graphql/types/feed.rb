class Types::Feed < Types::BaseObject
  description ''

  field :activities, Types::Union::FeedItem.connection_type,
    null: true,
    connection: false,
    extensions: [FeedConnectionExtension],
    description: ''

  def activities(first:, after: nil)
    Connections::FeedItemUnionConnection.new(
      object.activities,
      first: first,
      after: after,
      context: context
    )
  end
end
