class Types::MutationType < Types::BaseObject
  # Kitsu Pro
  field :pro, Types::ProMutation, null: false

  field :anime_update, mutation: Mutations::Anime::Update
  field :anime_create, mutation: Mutations::Anime::Create
  field :anime_delete, mutation: Mutations::Anime::Delete
end
