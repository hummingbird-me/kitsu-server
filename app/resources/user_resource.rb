class UserResource < BaseResource
  PRIVATE_FIELDS = %i[email password confirmed previous_email language time_zone country
                      share_to_global title_language_preference sfw_filter rating_system
                      theme facebook_id].freeze

  attributes :name, :past_names, :slug, :about, :location, :waifu_or_husbando, :followers_count,
    :following_count, :life_spent_on_anime, :birthday, :gender, :comments_count, :favorites_count,
    :likes_given_count, :reviews_count, :likes_received_count, :posts_count, :ratings_count,
    :media_reactions_count, :pro_expires_at, :title, :profile_completed, :feed_completed, :website
  attributes :avatar, :cover_image, format: :attachment
  attributes(*PRIVATE_FIELDS)

  has_one :waifu
  has_one :pinned_post
  has_many :followers
  has_many :following
  has_many :blocks
  has_many :linked_accounts
  has_many :profile_links
  has_many :user_roles
  has_many :library_entries
  has_many :favorites
  has_many :reviews
  has_many :stats
  has_many :notification_settings
  has_many :one_signal_players

  # DEPRECATED: this method just hides the fact that website has moved
  def website
    _model.profile_links.where(profile_link_site_id: 29).first&.url
  end

  def website=(value)
    _model.profile_links.where(profile_link_site_id: 29).update(url: value)
  end

  def self.attribute_caching_context(context)
    context[:current_user]&.resource_owner
  end

  def _remove
    @model.destroy_later
  end

  filter :slug
  filter :name, apply: ->(records, value, _o) { records.by_name(value.first) }
  filter :self, apply: ->(records, _v, options) {
    current_user = options[:context][:current_user]&.resource_owner
    records.where(id: current_user&.id) || User.none
  }

  index UsersIndex::User
  query :query,
    mode: :query,
    apply: ->(values, _ctx) {
      {
        bool: {
          should: [
            {
              multi_match: {
                fields: %w[name^2 past_names],
                query: values.join(' '),
                fuzziness: 2,
                max_expansions: 15,
                prefix_length: 1
              }
            },
            {
              multi_match: {
                fields: %w[name^2 past_names],
                query: values.join(' '),
                boost: 10
              }
            },
            {
              match_phrase_prefix: {
                name: values.join(' ')
              }
            }
          ]
        }
      }
    }
end
