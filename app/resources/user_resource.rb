class UserResource < BaseResource
  PRIVATE_FIELDS = %i[email password confirmed previous_email].freeze

  attributes :name, :past_names, :about, :bio, :about_formatted, :location,
    :website, :waifu_or_husbando, :to_follow, :followers_count, :created_at,
    :following_count, :onboarded, :life_spent_on_anime, :birthday, :gender,
    :facebook_id, :updated_at, :comments_count, :favorites_count, :last_login,
    :likes_given_count, :likes_received_count, :posts_count, :ratings_count,
    :reviews_count
  attributes :avatar, :cover_image, format: :attachment
  attributes(*PRIVATE_FIELDS)

  has_one :waifu
  has_many :followers
  has_many :following
  has_many :blocks
  has_many :linked_profiles
  has_many :media_follows
  has_many :user_roles
  has_many :library_entries
  has_many :favorites
  has_many :reviews

  filter :name, apply: -> (records, value, _o) { records.by_name(value.first) }
  filter :self, apply: -> (records, _v, options) {
    current_user = options[:context][:current_user]&.resource_owner
    records.where(id: current_user&.id) || User.none
  }

  index UsersIndex::User
  query :query,
    mode: :query,
    apply: -> (values, _ctx) {
      {
        multi_match: {
          fields: %w[name past_names],
          query: values.join(' '),
          fuzziness: 2,
          max_expansions: 15,
          prefix_length: 1
        }
      }
    }
end
