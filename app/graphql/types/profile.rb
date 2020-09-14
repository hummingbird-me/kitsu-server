class Types::Profile < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A user profile on Kitsu'

  field :id, ID, null: false

  field :slug, String,
    null: true,
    description: 'The URL-friendly identifier for this profile'

  field :url, String,
    null: true,
    description: 'A fully qualified URL to the profile'

  def url
    "https://kitsu/users/#{object.slug || object.id}"
  end

  field :name, String,
    null: false,
    description:
      <<~DESCRIPTION.squish
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

  field :waifu_or_husbando, String,
    null: true,
    description: <<~DESCRIPTION.squish
      The properly-gendered term for the user's waifu.
      This should normally only be 'Waifu' or 'Husbando' but some
      people are jerks, including the person who wrote this...
    DESCRIPTION

  field :pro_tier, Types::Enum::ProTier,
    null: true,
    description: 'The PRO level the user currently has'

  field :pro_message, String,
    null: true,
    description: 'The message this user has submitted to the Hall of Fame'

  field :location, String,
    null: true,
    description: "The user's general location"

  field :gender, String,
    null: true,
    description: 'What the user identifies as'

  field :birthday, GraphQL::Types::ISO8601Date,
    null: true,
    description: 'When the user was born'

  field :pinned_post, Types::Post,
    null: true,
    description: 'Post pinned to the user profile'

  field :stats, Types::ProfileStats,
    null: false,
    description: 'The different stats we calculate for this user.'

  def stats
    object
  end

  field :followers, Types::Profile.connection_type, null: false do
    description 'People that follow the user'
    argument :sort, [Types::Input::Profile::Sort], required: false
    argument :followed_at, [Types::Input::Follow::Sort], required: false
  end

  def followers(sort: nil, followed_at: nil)
    AssociationLoader.for(object.class, :followers, policy: :follow).scope(object).then do |follows|
      RecordLoader.for(object.class).load_many(follows.pluck(:follower_id))
    end
  end

  field :following, Types::Profile.connection_type, null: false do
    description 'People the user is following'
    argument :sort, [Types::Input::Profile::Sort], required: false
    argument :following_at, [Types::Input::Follow::Sort], required: false
  end

  def following(sort: nil, following_at: nil)
    AssociationLoader.for(object.class, :following, policy: :follow).scope(object).then do |follows|
      RecordLoader.for(object.class).load_many(follows.pluck(:followed_id))
    end
  end

  field :posts, Types::Post.connection_type, null: false do
    description 'All posts this user has made'
    argument :sort, [Types::Input::Post::Sort], required: false
  end

  def posts(sort: nil)
    AssociationLoader.for(object.class, :posts).scope(object)
  end

  field :comments, Types::Comment.connection_type, null: false do
    description 'All comments to any post this user has made'
    argument :sort, [Types::Input::Comment::Sort], required: false
  end

  def comments(sort: nil)
    AssociationLoader.for(object.class, :comments).scope(object)
  end

  field :library, Types::Library,
    null: false,
    description: 'The user library of their media'

  def library
    object
  end

  field :library_events, Types::LibraryEvent.connection_type, null: false do
    description 'A list of library events for this user'

    argument :kind, [Types::Enum::LibraryEventKind], required: false
  end

  def library_events(kind: nil)
    filters = { kind: kind }.compact

    AssociationLoader.for(object.class, :library_events).scope(object).then do |library_events|
      library_events.where(filters)
    end
  end

  field :site_links, Types::SiteLink.connection_type, null: true do
    description 'Links to the user on other (social media) sites'

    argument :sort, [Types::Input::SiteLink::Sort], required: false
  end

  def site_links(sort: nil)
    AssociationLoader.for(object.class, :profile_links).scope(object)
  end

  field :media_reactions, Types::MediaReaction.connection_type, null: false do
    description 'Media reactions written by this user'

    argument :sort, [Types::Input::MediaReaction::Sort], required: false
  end

  def media_reactions(sort: nil)
    AssociationLoader.for(object.class, :media_reactions).scope(object)
  end

  field :favorites, Types::Favorite.connection_type, null: false do
    description 'Favorite media, characters, and people'

    argument :sort, [Types::Input::Favorite::Sort], required: false
  end

  def favorites(sort: nil)
    AssociationLoader.for(object.class, :favorites).scope(object)
  end
end
