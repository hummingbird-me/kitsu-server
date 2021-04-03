class Types::Installment < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description ''

  field :id, ID, null: false

  field :release_order, Integer,
    null: true,
    description: ''

  field :alternative_order, Integer,
    null: true,
    description: ''

  field :tag, Types::Enum::InstallmentTag,
    null: true,
    description: ''

  field :media, Types::Interface::Media,
    null: false,
    description: 'The media related to this installment'

  def media
    RecordLoader.for(object.media_type.safe_constantize).load(object.media_id)
  end

  field :franchise, Types::Franchise,
    null: false,
    description: 'The franchise related to this installment'
end
