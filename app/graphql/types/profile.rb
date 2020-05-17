class Types::Profile < Types::BaseObject
  description 'A user profile on Kitsu'

  field :id, ID, null: false

  field :slug, String,
    null: true,
    description: 'The URL-friendly identifier for this profile'

  field :name, String,
    null: false,
    description: 'A non-unique, user-visible name for the profile.  Can contain spaces, emoji, etc.'

  field :url, String,
    null: true,
    description: 'The full URL for this profile'

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

  field :about_formatted, String,
    null: true,
    description: 'Your about section formatted.'

  field :bio, String,
    null: false,
    description: 'Description of your hobbies, interests, etc...'

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

  field :location, String,
    null: true,
    description: 'Your general location to be displayed on your profile.'

  field :gender, String,
    null: true,
    description: 'What you identify as.'

  field :birthday, GraphQL::Types::ISO8601Date,
    null: true,
    description: 'When you were born, or something like that...'

  field :time_zone, String,
    null: true,
    description: 'The time_zone for this user.'

  field :country, String,
    null: true,
    description: 'The country you are in currently.'

  field :followers, Types::Profile.connection_type,
    null: false,
    description: 'The people the user follows'

  field :following, Types::Profile.connection_type,
    null: false,
    description: 'The people the user is following'

  field :library_entries, [Types::LibraryEntry], null: false do
    description 'All media related to the profile'

    argument :media_type, Types::MediaTypeChoice, required: true
  end

  field :pinned_post, Types::Post,
    null: true,
    description: 'Post pinned to the user profile'

  def url
    "https://kitsu/users/#{object.slug || object.id}"
  end

  def followers
    AssociationLoader.for(object.class, :followers).load(object)
  end

  def following
    AssociationLoader.for(object.class, :following).load(object)
  end

  def library_entries(media_type: nil)
    object.library_entries.where(media_type: media_type)
  end
end
