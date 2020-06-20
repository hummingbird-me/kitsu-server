class Types::Account < Types::BaseObject
  description 'A user account on Kitsu'

  field :id, ID, null: false

  field :email, [String],
    null: false,
    description: 'The email addresses associated with this account'

  # TODO: allow for multiple emails per user in the actual database
  def email
    [object.email]
  end

  field :profile, Types::Profile,
    null: false,
    description: 'The profile for this account'

  def profile
    object
  end

  field :pro_subscription, Types::ProSubscription,
    null: true,
    description: 'The PRO subscription for this account'

  field :max_pro_streak, Integer,
    null: true,
    description: 'Longest period an account has had a PRO subscription for in seconds'

  field :facebook_id, String,
    null: true,
    description: 'Facebook account linked to the account'

  field :twitter_id, String,
    null: true,
    description: 'Twitter account linked to the account'

  field :sfw_filter, Boolean,
    null: true,
    description: 'Whether Not Safe For Work content is accessible'

  field :theme, Types::AccountTheme,
    null: false,
    description: 'Preferred UI theme for the account'

  field :language, String,
    null: true,
    description: 'Primary language for the account'

  field :title_language_preference, Types::TitleLanguagePreference,
    null: true,
    description: 'Preferred language for media titles'

  field :rating_system, Types::RatingSystem,
    null: false,
    description: 'Media rating system used for the account'

  field :time_zone, String,
    null: true,
    description: 'Time zone of the account'

  field :country, String,
    null: true,
    description: 'Country the account resides in'
end
