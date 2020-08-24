class Types::Favorite < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'Favorite media, characters, and people for a user'

  field :id, ID, null: false

  field :item, Types::Union::FavoriteItem,
    null: false,
    description: 'The kitsu object that is mapped'

  field :user, Types::Profile,
    null: false,
    description: 'The user who favorited this item'
end
