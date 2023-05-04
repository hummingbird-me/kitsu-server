class Types::MutationType < Types::BaseObject
  def self.fancy_mutation(
    klass,
    name: klass.name.split('::')[1..].join.camelize(:lower)
  )
    field name, mutation: klass
  end

  fancy_mutation Mutations::Account::Create
  field :pro, Mutations::Pro, null: false
  field :account, Mutations::Account, null: false
  field :profile, Mutations::Profile, null: false
  field :block, Mutations::Block, null: false
  field :anime, Mutations::Anime, null: false
  field :episode, Mutations::Episode, null: false
  field :library_entry, Mutations::LibraryEntry, null: false
  field :change_password, mutation: Mutations::Account::ChangePassword
  field :favorite, Mutations::Favorite, null: false
  field :media_reaction, Mutations::MediaReaction, null: false
  field :mapping, Mutations::Mapping, null: false
  field :post, Mutations::Post, null: false
  field :wiki_submission, Mutations::WikiSubmission, null: false
  field :profile_link, Mutations::ProfileLink, null: false

  # HACK: The GraphQL runtime gets confused by the nil objects in mutations. So we override the
  # object method to just return a hash with all fields being hashes.
  def object
    Hash.new { |hash, key| hash[key] = {} }
  end
end
