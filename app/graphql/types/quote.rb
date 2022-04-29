class Types::Quote < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A quote from a media'

  # Identifiers
  field :id, ID, null: false

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media this quote is excerpted from'

  field :lines, Types::QuoteLine.connection_type,
    null: false,
    description: 'The lines of the quote'

  def lines
    Loaders::AssociationLoader.for(Quote, :lines, policy: :quote_line).scope(object).then(&:to_a)
  end
end
