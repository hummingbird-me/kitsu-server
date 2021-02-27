class Types::MutationType < Types::BaseObject
  field :pro, Mutations::Pro, null: false
  field :anime, Mutations::Anime, null: false
  field :episode, Mutations::Episode, null: false
  field :library_entry, Mutations::LibraryEntry, null: false
  field :mapping, Mutations::Mapping, null: false
  field :post, Mutations::Post, null: false

  # HACK: The GraphQL runtime gets confused by the nil objects in mutations. So we override the
  # object method to just return a hash with all fields being hashes.
  def object
    Hash.new { |hash, key| hash[key] = {} }
  end
end
