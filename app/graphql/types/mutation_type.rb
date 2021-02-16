class Types::MutationType < Types::BaseObject
  field :pro, Mutations::Pro, null: false
  field :anime, Mutations::Anime, null: true
  field :episode, Mutations::Episode, null: true
  field :library_entry, Mutations::LibraryEntry, null: true
  field :mapping, Mutations::Mapping, null: true
  field :post, Mutations::Post, null: true
end
