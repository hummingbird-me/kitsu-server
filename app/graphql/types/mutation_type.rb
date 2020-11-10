class Types::MutationType < Types::BaseObject
  field :account, Types::Mutations::AccountMutation, null: true
  field :anime, Types::Mutations::AnimeMutation, null: true
  field :episode, Types::Mutations::EpisodeMutation, null: true
  field :library_entry, Types::Mutations::LibraryEntryMutation, null: true
  field :mapping, Types::Mutations::MappingMutation, null: true
  field :pro, Types::Mutations::ProMutation, null: false
end
