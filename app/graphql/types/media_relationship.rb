# frozen_string_literal: true

class Types::MediaRelationship < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A relationship from one media to another'

  field :source, Types::Interface::Media,
    null: false,
    description: 'The source media'

  def source
    Loaders::RecordLoader.for(
      object.source_type.safe_constantize,
      token: context[:token]
    ).load(object.source_id)
  end

  field :destination, Types::Interface::Media,
    null: false,
    description: 'The destination media'

  def destination
    Loaders::RecordLoader.for(
      object.destination_type.safe_constantize,
      token: context[:token]
    ).load(object.destination_id)
  end

  field :kind, Types::Enum::MediaRelationshipKind,
    null: false,
    method: :role,
    description: 'The kind of relationship'
end
