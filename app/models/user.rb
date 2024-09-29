# == Schema Information
#
# Table name: users
#
#  id                          :integer          not null, primary key
#  about                       :string(500)      default(""), not null
#  about_formatted             :text
#  ao_password                 :string
#  ao_pro                      :integer
#  approved_edit_count         :integer          default(0)
#  avatar_content_type         :string(255)
#  avatar_file_name            :string(255)
#  avatar_file_size            :integer
#  avatar_meta                 :text
#  avatar_processing           :boolean
#  avatar_updated_at           :datetime
#  bio                         :string(140)      default(""), not null
#  birthday                    :date
#  comments_count              :integer          default(0), not null
#  confirmed_at                :datetime
#  country                     :string(2)
#  cover_image_content_type    :string(255)
#  cover_image_file_name       :string(255)
#  cover_image_file_size       :integer
#  cover_image_meta            :text
#  cover_image_processing      :boolean
#  cover_image_updated_at      :datetime
#  current_sign_in_at          :datetime
#  deleted_at                  :datetime
#  dropbox_secret              :string(255)
#  dropbox_token               :string(255)
#  email                       :string(255)      default(""), indexed
#  favorites_count             :integer          default(0), not null
#  feed_completed              :boolean          default(FALSE), not null
#  followers_count             :integer          default(0)
#  following_count             :integer          default(0)
#  gender                      :string
#  import_error                :string(255)
#  import_from                 :string(255)
#  import_status               :integer
#  language                    :string
#  last_backup                 :datetime
#  last_recommendations_update :datetime
#  last_sign_in_at             :datetime
#  life_spent_on_anime         :integer          default(0), not null
#  likes_given_count           :integer          default(0), not null
#  likes_received_count        :integer          default(0), not null
#  location                    :string(255)
#  mal_username                :string(255)
#  media_reactions_count       :integer          default(0), not null
#  name                        :string(255)
#  ninja_banned                :boolean          default(FALSE)
#  password_digest             :string(255)      default("")
#  past_names                  :string           default([]), not null, is an Array
#  posts_count                 :integer          default(0), not null
#  previous_email              :string
#  pro_expires_at              :datetime
#  profile_completed           :boolean          default(FALSE), not null
#  rating_system               :integer          default(0), not null
#  ratings_count               :integer          default(0), not null
#  recommendations_up_to_date  :boolean
#  rejected_edit_count         :integer          default(0)
#  remember_created_at         :datetime
#  reviews_count               :integer          default(0), not null
#  sfw_filter                  :boolean          default(TRUE)
#  share_to_global             :boolean          default(TRUE), not null
#  sign_in_count               :integer          default(0)
#  slug                        :citext           indexed
#  stripe_token                :string(255)
#  subscribed_to_newsletter    :boolean          default(TRUE)
#  theme                       :integer          default(0), not null
#  time_zone                   :string
#  title                       :string
#  title_language_preference   :string(255)      default("canonical")
#  to_follow                   :boolean          default(FALSE), indexed
#  waifu_or_husbando           :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  ao_facebook_id              :string
#  ao_id                       :string
#  facebook_id                 :string(255)      indexed
#  pinned_post_id              :integer
#  pro_membership_plan_id      :integer
#  stripe_customer_id          :string(255)
#  twitter_id                  :string
#  waifu_id                    :integer          indexed
#
# Indexes
#
#  index_users_on_email        (email) UNIQUE
#  index_users_on_facebook_id  (facebook_id) UNIQUE
#  index_users_on_slug         (slug) UNIQUE
#  index_users_on_to_follow    (to_follow)
#  index_users_on_waifu_id     (waifu_id)
#
# Foreign Keys
#
#  fk_rails_bc615464bf  (pinned_post_id => posts.id)
#
class User < ApplicationRecord
  include AvatarUploader::Attachment(:avatar)
  include CoverImageUploader::Attachment(:cover_image)

  PAST_NAMES_LIMIT = 10
  PAST_IPS_LIMIT = 20
  RESERVED_NAMES = %w[
    admin administrator connect dashboard developer developers edit favorites
    feature featured features feed follow followers following hummingbird index
    javascript json kitsu sysadmin sysadministrator system unfollow user users
    wiki you staff mod
  ].to_set.freeze
  CONTROL_CHARACTERS = /\p{Line_Separator}|\p{Paragraph_Separator}|\p{Other}/u.freeze
  BANNED_CHARACTERS = [
    # Swastikas
    "\u534D",
    "\u5350"
  ].join.freeze

  enum rating_system: { simple: 0, advanced: 1, regular: 2 }
  enum status: { unregistered: 0, registered: 1, aozora: 2 }
  enum theme: { light: 0, dark: 1 }
  enum pro_tier: { ao_pro: 0, ao_pro_plus: 1, pro: 2, patron: 3 }
  enum email_status: { email_unconfirmed: 0, email_confirmed: 1, email_bounced: 2 }
  enum title_language_preference: { canonical: 0, romanized: 1, localized: 2 }
  enum sfw_filter_preference: { sfw: 0, nsfw_sometimes: 1, nsfw_everywhere: 2 }

  rolify
  flag :permissions, %i[admin community_mod database_mod]
  has_secure_password validations: false
  update_index('users#user') { self }
  update_algolia('AlgoliaUsersIndex')

  belongs_to :waifu, optional: true, class_name: 'Character'
  belongs_to :pinned_post, class_name: 'Post', optional: true
  has_one :pro_subscription, dependent: :destroy, required: false
  has_many :followers, class_name: 'Follow', foreign_key: 'followed_id', inverse_of: :followed
  has_many :following, class_name: 'Follow', foreign_key: 'follower_id', inverse_of: :follower
  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :blocks, dependent: :delete_all
  has_many :blocked, class_name: 'Block', foreign_key: 'blocked_id', dependent: :delete_all
  has_many :linked_accounts, dependent: :delete_all
  has_many :profile_links, dependent: :delete_all
  has_many :user_roles, dependent: :delete_all
  has_many :library_events, dependent: :delete_all
  has_many :library_entries, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :media_reactions, dependent: :destroy
  has_many :media_reaction_votes, dependent: :destroy
  has_many :comment_likes
  has_many :post_likes
  has_many :post_follows, dependent: :destroy
  has_many :review_likes, dependent: :destroy
  has_many :list_imports, dependent: :delete_all
  has_many :group_action_logs, dependent: :destroy
  has_many :group_bans, dependent: :delete_all
  has_many :group_invites, dependent: :destroy
  has_many :group_members, dependent: :destroy
  has_many :group_reports
  has_many :group_reports_as_moderator, class_name: 'GroupReport', foreign_key: 'moderator_id'
  has_many :group_ticket_messages, dependent: :destroy
  has_many :group_tickets, dependent: :destroy
  has_many :leader_chat_messages, dependent: :destroy
  has_many :reports
  has_many :reports_as_moderator, class_name: 'Report', foreign_key: 'moderator_id'
  has_many :site_announcements
  has_many :stats, dependent: :delete_all
  has_many :library_events, dependent: :delete_all
  has_many :notification_settings, dependent: :delete_all
  has_many :one_signal_players, dependent: :delete_all
  has_many :reposts, dependent: :destroy
  has_many :ip_addresses, dependent: :delete_all, class_name: 'UserIpAddress'
  has_many :category_favorites, dependent: :delete_all
  has_many :quotes, dependent: :nullify
  has_many :wiki_submissions
  has_many :wiki_submission_logs

  validates :email, format: { with: /\A.+@.+\.[a-z]+\z/, message: 'is not an email' },
                    if: :email_changed?, allow_blank: true
  validates :email, :name, :password, :slug, absence: true, if: :unregistered?
  validates :email, :name, :password_digest, presence: true, if: :registered?
  validates :email, uniqueness: { case_sensitive: false }, if: :email_changed?, allow_blank: true
  validates :email, real_email: true, if: ->(user) {
    Flipper.enabled?(:email_validation) && user.email_changed?
  }
  with_options if: :slug_changed?, allow_nil: true do
    validates :slug, uniqueness: { case_sensitive: false }
    validates :slug, format: {
      with: /\A[_A-Za-z0-9]+\z/,
      message: 'can only contain letters, numbers, and underscores'
    }
    validates :slug, format: {
      with: /\A[A-Za-z0-9]/,
      message: 'must begin with a letter or number'
    }
    validates :slug, format: {
      without: /\A[0-9]*\z/,
      message: 'cannot be entirely numbers'
    }
    validates :slug, length: 3..20
  end
  validate :not_reserved_slug, if: ->(user) { user.slug.present? && user.slug_changed? }
  validate :not_reserved_name, if: :name_changed?
  validate :not_taken_on_aozora, on: :create
  validates :name, presence: true,
                   length: { minimum: 3, maximum: 20 },
                   if: ->(user) { user.registered? && user.name_changed? }
  validates :name, format: {
    without: CONTROL_CHARACTERS,
    message: 'cannot contain control characters, you silly haxx0r'
  }, if: ->(user) { user.registered? && user.name_changed? }
  validate :not_banned_characters
  validates :about, length: { maximum: 500 }
  validates :gender, length: { maximum: 20 }
  validates :password, length: { maximum: 72 }, if: :registered?
  validates :facebook_id, uniqueness: true, allow_nil: true

  scope :active, -> { where(deleted_at: nil) }
  scope :by_slug, ->(*slugs) { where(slug: slugs&.flatten) }
  scope :by_name, ->(*names) {
    where('lower(users.name) IN (?)', names&.flatten&.compact&.map(&:downcase))
  }
  scope :by_email, ->(*emails) {
    where('lower(users.email) IN (?)', emails&.flatten&.compact&.map(&:downcase))
  }
  scope :blocking, ->(*users) { where.not(id: users.flatten) }
  scope :followed_first, ->(user) {
    user_id = sanitize_sql(user.id)
    joins(Arel.sql(<<-SQL.squish)).order(Arel.sql('(f.id IS NULL) ASC'))
      LEFT OUTER JOIN follows f
      ON f.followed_id = users.id
      AND f.follower_id = #{user_id}
    SQL
  }

  alias_method :flipper_id, :id

  # @return [User] the system user
  def self.system_user
    User.find(-11)
  end

  # @return [User,nil] the current user as stored in the Thread-local variable
  def self.current
    Thread.current[:current_user]
  end

  # Override the version provided by has_secure_password to accept the aozora password too
  # @param unencrypted_password [String] the unencrypted password to test
  def authenticate(unencrypted_password)
    [password_digest, ao_password].compact.any? do |password|
      BCrypt::Password.new(password).is_password?(unencrypted_password)
    end && self
  end

  def self.find_for_auth(identification)
    by_email(identification).or(by_slug(identification)).first
  end

  def not_reserved_slug
    errors.add(:slug, 'is reserved') if RESERVED_NAMES.include?(slug&.downcase)
  end

  def not_reserved_name
    errors.add(:name, 'is reserved') if RESERVED_NAMES.include?(name.downcase)
  end

  def not_banned_characters
    errors.add(:name, 'contains banned characters') if name&.count(BANNED_CHARACTERS) != 0
  end

  def not_taken_on_aozora
    return unless Rails.env.production?
    if Zorro::DB::User.find(email: /\A\s*#{email}\s*\z/i).count.nonzero? && ao_id.blank?
      errors.add(:email, 'is already taken by an Aozora user')
    end
  end

  def pro_tier
    tier = super
    # If they're Aozora pro, expiration doesn't apply
    return tier if tier.to_s.start_with?('ao_')
    # Otherwise check the expiration
    tier unless pro_expires_at&.past?
  end

  def pro?
    !pro_tier.nil?
  end

  def ao_pro
    # If they're ao_pro then strip the ao_ prefix and return it
    pro_tier.to_s.sub('ao_', '').to_sym if pro_tier.to_s.start_with?('ao_')
  end

  def pro_streak
    return unless pro_started_at
    streak_end = [Time.now, pro_expires_at].compact.min
    streak_end - pro_started_at
  end

  def sfw_filter?
    sfw_filter_preference == 'sfw'
  end

  def stripe_customer
    @stripe_customer ||= if stripe_customer_id
                           Stripe::Customer.retrieve(stripe_customer_id)
                         else
                           customer = Stripe::Customer.create(email: email)
                           self.stripe_customer_id = customer.id
                           customer
                         end
  end

  def blocked?(user)
    Block.exists?(user: [self, user], blocked: [self, user])
  end

  def confirmed
    return false if confirmed_at.nil?
    confirmed_at <= Time.now
  end

  def confirmed=(val)
    self.confirmed_at = Time.now if val
  end

  def previous_name
    past_names.first
  end

  def one_signal_player_ids
    one_signal_players.pluck(:player_id).compact
  end

  def title_preference_list
    case title_language_preference
    when :canonical then %i[canonical]
    when :romanized then %i[romanized translated canonical]
    when :localized then %i[translated romanized canonical]
    end
  end

  def add_ip(new_ip)
    ip_addresses.where(ip_address: new_ip).first_or_create
  rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
    ip_addresses.where(ip_address: new_ip).first
  end

  def alts
    alts = {}
    user_ips = ip_addresses.select(:ip_address)
    user_ip_count = user_ips.count
    shared_ips = UserIpAddress.where(ip_address: user_ips).where.not(user: self).includes(:user)
    alt_ip_counts = UserIpAddress.where(user_id: shared_ips.select(:user_id)).group(:user_id).count

    shared_ips.group(:user).count.each do |alt, shared_ips_count|
      alts[alt] = shared_ips_count.to_f / [[user_ip_count, alt_ip_counts[alt.id]].min, 2].max
    end
    alts.sort_by { |_, v| v }.reverse
  end

  def update_title
    if permissions.admin?
      self.title = 'Staff'
    elsif permissions.database_mod? || permissions.community_mod?
      self.title = 'Mod'
    end
  end

  def admin?
    permissions.admin? || permissions.database_mod? || permissions.community_mod?
  end

  def profile_feed
    @profile_feed ||= ProfileFeed.new(id)
  end

  def timeline
    @timeline ||= TimelineFeed.new(id)
  end

  def notifications
    @notifications ||= NotificationsFeed.new(id)
  end

  def site_announcements_feed
    @site_announcements_feed ||= SiteAnnouncementsFeed.new(id)
  end

  def update_feed_completed
    return self if feed_completed?
    if library_entries.rated.count >= 5 && following.count >= 5 &&
       comments.count.nonzero? && post_likes.count >= 3
      assign_attributes(feed_completed: true)
    end
    self
  end

  def update_feed_completed!
    update_feed_completed.save!
  end

  def update_profile_completed
    return self if profile_completed?
    if library_entries.rated.count >= 5 && avatar.present? &&
       cover_image.present? && about.present? && favorites.count.nonzero?
      assign_attributes(profile_completed: true)
    end
    self
  end

  def update_profile_completed!
    update_profile_completed.save!
  end

  def enabled_features
    features = Flipper.preload_all
    flags = features.map { |f| [f.name, f.enabled?(self)] }.to_h
    flags.select { |_, enabled| enabled }.keys
  end

  before_validation if: :email_changed? do
    # Strip the email and downcase it just for good measure
    self.email = email&.strip&.downcase
  end

  before_destroy do
    UserDeletionService.new(self).delete
  end

  after_commit on: :create do
    # Set up feeds
    profile_feed.setup!
    timeline.setup!
    site_announcements_feed.setup!

    # Automatically join "Kitsu" group
    GroupMember.create!(user: self, group: Group.kitsu) if Group.kitsu
  end

  after_create do
    # Set up Notification Settings for User
    NotificationSetting.setup!(self)
  end

  before_update do
    self.max_pro_streak = [max_pro_streak, pro_streak].compact.max
    if name_changed?
      # Push it onto the front and limit
      self.past_names = [name_was, *past_names].first(PAST_NAMES_LIMIT)
    end
    self.previous_email = nil if confirmed_at_changed?
    self.previous_email = email_was if email_changed?
    update_title
    update_profile_completed
    update_feed_completed
  end

  after_commit on: :update do
    # Update email on Stripe
    stripe_customer.save(email: email) if previous_changes['email']
  end

  after_commit if: ->(u) { u.previous_changes['email'] && !Rails.env.staging? } do
    self.confirmed_at = nil
    # Send Confirmation Email
    Accounts::SendConfirmationEmailWorker.perform_async(self)
  end
end
