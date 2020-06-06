class Types::Profile < Types::BaseObject
  description 'A user profile on Kitsu'

  field :id, ID, null: false
  field :slug, String,
    null: true,
    description: 'The URL-friendly identifier for this profile'
  field :url, String,
    null: true,
    description: 'The URL for this profile'

  # Name
  field :name, String,
    null: false,
    description: 'A non-unique, user-visible name for the profile.  Can contain spaces, emoji, etc.'

  field :avatar_image, Types::Image,
    method: :avatar,
    null: true,
    description: 'An avatar image to easily identify this profile'

  field :banner_image, Types::Image,
    method: :cover_image,
    null: true,
    description: 'A banner to display at the top of the profile'

  field :about, String,
    null: true,
    description: 'A short biographical blurb about this profile'

  field :waifu, Types::Character,
    null: true,
    description: 'The character this profile has declared as their waifu or husbando'

  field :waifu_or_husbando, String,
    null: true,
    description: 'The user-provided (unsanitized) string used to identify the role of the waifu'

  field :pro_tier, Types::ProTier,
    null: true,
    description: 'The level of Pro this user currently has'

  field :pro_message, String,
    null: true,
    description: 'The message this user has submitted for the Hall of Fame'

  field :library_entries, Types::MediaAssociation,
    null: false,
    description: 'The user Library Entries which make up their Media List'

  def url
    "https://kitsu/users/#{object.slug || object.id}"
  end

  def library_entries
    object
  end
end
