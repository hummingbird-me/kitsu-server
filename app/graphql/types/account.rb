class Types::Account < Types::BaseObject
  description 'A user account on Kitsu'

  field :id, ID, null: false

  field :email, [String],
    null: false,
    description: 'The email addresses associated with this account'

  field :profile, Types::Profile,
    null: false,
    description: 'The profile for this account'

  field :pro_subscription, Types::ProSubscription,
    null: true,
    description: 'The PRO subscription for this account'

  #
  # field :pro_started_at, GraphQL::Types::ISO8601DateTime,
  #   null: true,
  #   description: 'When your pro subscription started'
  #
  # # unsure if this is the right place
  # field :pro_expires_at, GraphQL::Types::ISO8601DateTime,
  #   null: true,
  #   description: 'When your pro subscription expires'

  field :max_pro_streak, Integer,
    null: true,
    description: ''

  field :facebook_id, String,
    null: true,
    description: 'Facebook account linked to the user.'

  field :twitter_id, String,
    null: true,
    description: 'Twitter account linked to user.'

  field :sfw_filter, Boolean,
    null: true,
    description: 'Whether Not-Safe-for-Work content is shown.'

  field :mal_username, String,
    null: true,
    description: 'Your MyAnimeList username.'

  # field :past_names, [String, null: true],
  #   description: 'A list of this users past names'

  field :theme, Integer,
    null: false,
    description: 'Options are the Devil! - Josh'

  field :language, String,
    null: true,
    description: 'Primary language for this user.'

  field :title_language_preference, String,
    null: true,
    description: 'Your preferred language of choice for media to display as.'

  field :rating_system, Types::RatingSystem,
    null: false,
    description: 'The system used when rating media'

  # TODO: allow for multiple emails per user in the actual database
  def email
    [object.email]
  end

  def profile
    object
  end
end
