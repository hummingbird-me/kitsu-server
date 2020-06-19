class Types::Profile < Types::BaseObject
  description 'A user profile on Kitsu'

  field :id, ID, null: false

  field :slug, String,
    null: true,
    description: 'A unique URL-friendly identifier used for the profile URL'

  field :url, String,
    null: true,
    description: 'A fully qualified URL to the profile'

  field :name, String,
    null: false,
    description:
      <<~DESCRIPTION.strip
        A non-unique publicly visible name for the profile.
        Minimum of 3 characters and any valid Unicode character
      DESCRIPTION

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

  field :waifu_or_husbando, Types::WaifuOrHusbando,
    null: true,
    description:
      <<~DESCRIPTION.squish
        The user-provided (unsanitized) string used to identify
        the role of the waifu. 'Waifu' or 'Husbando'
      DESCRIPTION

  field :pro_tier, Types::Enum::ProTier,
    null: true,
    description: 'The PRO level the user currently has'

  field :pro_message, String,
    null: true,
    description: 'The message this user has submitted to the Hall of Fame'

  field :stats, Types::ProfileStats,
    null: false,
    description: 'The different stats we calculate for this user.'

  field :location, String,
    null: true,
    description: "The user's general location"

  field :gender, String,
    null: true,
    description: 'What the user identifies as'

  field :birthday, GraphQL::Types::ISO8601Date,
    null: true,
    description: 'When the user was born'

  field :followers, Types::Profile.connection_type,
    null: false,
    description: 'People that follow the user'

  field :following, Types::Profile.connection_type,
    null: false,
    description: 'People the user is following'

  def url
    "https://kitsu/users/#{object.slug || object.id}"
  end

  def stats
    object
  end

  def followers
    AssociationLoader.for(object.class, :followers, policy: :follow).scope(object).then do |follows|
      RecordLoader.for(object.class).load_many(follows.pluck(:follower_id))
    end
  end

  def following
    AssociationLoader.for(object.class, :following, policy: :follow).scope(object).then do |follows|
      RecordLoader.for(object.class).load_many(follows.pluck(:followed_id))
    end
  end
end
