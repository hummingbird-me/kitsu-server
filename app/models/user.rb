# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: users
#
#  id                          :integer          not null, primary key
#  about                       :string(500)      default(""), not null
#  about_formatted             :text
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
# rubocop:enable Metrics/LineLength

class User < ApplicationRecord
  include WithCoverImage
  include WithAvatar

  PAST_NAMES_LIMIT = 10
  PAST_IPS_LIMIT = 20
  RESERVED_NAMES = %w[
    admin administrator connect dashboard developer developers edit favorites
    feature featured features feed follow followers following hummingbird index
    javascript json kitsu sysadmin sysadministrator system unfollow user users
    wiki you staff mod
  ].to_set.freeze
  CONTROL_CHARACTERS = /\p{Line_Separator}|\p{Paragraph_Separator}|\p{Other}/u
  BANNED_CHARACTERS = [
    # Swastikas
    "\u534D",
    "\u5350"
  ].join.freeze

  enum rating_system: %i[simple advanced regular]
  rolify after_add: :update_title, after_remove: :update_title
  has_secure_password validations: false
  enum status: %i[unregistered registered]
  update_index('users#user') { self }
  update_algolia('AlgoliaUsersIndex')
  enum theme: %i[light dark]

  belongs_to :pro_membership_plan, required: false
  belongs_to :waifu, required: false, class_name: 'Character'
  belongs_to :pinned_post, class_name: 'Post', required: false
  has_many :followers, class_name: 'Follow', foreign_key: 'followed_id',
                       dependent: :destroy
  has_many :following, class_name: 'Follow', foreign_key: 'follower_id',
                       dependent: :destroy
  has_many :comments
  has_many :posts
  has_many :blocks, dependent: :destroy
  has_many :blocked, class_name: 'Block', foreign_key: 'blocked_id',
                     dependent: :destroy
  has_many :linked_accounts, dependent: :destroy
  has_many :profile_links, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :library_entries, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :media_reactions, dependent: :destroy
  has_many :media_reaction_votes, dependent: :destroy
  has_many :comment_likes, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  has_many :post_follows, dependent: :destroy
  has_many :review_likes, dependent: :destroy
  has_many :list_imports, dependent: :destroy
  has_many :group_action_logs, dependent: :destroy
  has_many :group_bans, dependent: :destroy
  has_many :group_invites, dependent: :destroy
  has_many :group_members, dependent: :destroy
  has_many :group_reports
  has_many :group_reports_as_moderator, class_name: 'GroupReport',
                                        foreign_key: 'moderator_id'
  has_many :group_ticket_messages, dependent: :destroy
  has_many :group_tickets, dependent: :destroy
  has_many :leader_chat_messages, dependent: :destroy
  has_many :reports
  has_many :reports_as_moderator, class_name: 'Report',
                                  foreign_key: 'moderator_id'
  has_many :site_announcements
  has_many :stats, dependent: :destroy
  has_many :library_events, dependent: :destroy
  has_many :notification_settings, dependent: :destroy
  has_many :one_signal_players, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_many :ip_addresses, dependent: :destroy, class_name: 'UserIpAddress'
  validates :email, :name, :password, :slug, absence: true, if: :unregistered?
  validates :email, :name, :password_digest, presence: true, if: :registered?
  validates :email, uniqueness: { case_sensitive: false },
                    if: ->(user) { user.registered? && user.email_changed? }
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

  scope :active, ->() { where(deleted_at: nil) }
  scope :by_slug, ->(*slugs) { where(slug: slugs&.flatten) }
  scope :by_name, ->(*names) {
    where('lower(users.name) IN (?)', names&.flatten&.map(&:downcase))
  }
  scope :by_email, ->(*emails) {
    where('lower(users.email) IN (?)', emails&.flatten&.map(&:downcase))
  }
  scope :blocking, ->(*users) { where.not(id: users.flatten) }
  scope :followed_first, ->(user) {
    user_id = sanitize(user.id)
    joins(<<-SQL.squish).order('(f.id IS NULL) ASC')
      LEFT OUTER JOIN follows f
      ON f.followed_id = users.id
      AND f.follower_id = #{user_id}
    SQL
  }

  alias_method :flipper_id, :id

  def self.find_for_auth(identification)
    by_email(identification).or(by_slug(identification)).first
  end

  def not_reserved_slug
    errors.add(:slug, 'is reserved') if RESERVED_NAMES.include?(slug&.downcase)
  end

  def not_banned_characters
    errors.add(:name, 'contains banned characters') if name&.count(BANNED_CHARACTERS) != 0
  end

  def pro?
    return false if pro_expires_at.nil?
    pro_expires_at >= Time.now
  end

  def blocked?(user)
    blocks.where(user: [self, user], blocked: [self, user]).exists?
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

  def add_ip(new_ip)
    ip_addresses.where(ip_address: new_ip).first_or_create
  rescue ActiveRecord::RecordNotUnique # This can happen if two requests run at the same time
    ip_addresses.where(ip_address: new_ip).first
  end

  def alts
    UserIpAddress.where(ip_address: ip_addresses.select(:ip_address)).includes(:user).map(&:user)
  end

  def update_title(_role)
    if has_role?(:admin)
      update(title: 'Staff')
    elsif has_role?(:admin, Anime) || has_role?(:mod)
      update(title: 'Mod')
    end
  end

  def admin?
    title == 'Staff' || title == 'Mod'
  end

  def profile_feed
    @profile_feed ||= ProfileFeed.new(id)
  end

  def timeline
    @timeline ||= TimelineFeed.new(id)
  end

  def group_timeline
    @group_timeline ||= GroupTimelineFeed.new(id)
  end

  def notifications
    @notifications ||= NotificationsFeed.new(id)
  end

  def site_announcements_feed
    @site_announcements_feed ||= SiteAnnouncementsFeed.new(id)
  end

  def library_feed
    @library_feed ||= PrivateLibraryFeed.new(id)
  end

  def interest_timeline_for(interest)
    "#{interest.to_s.classify}TimelineFeed".safe_constantize.new(id)
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

  before_destroy do
    # Destroy personal posts
    posts.where(target_group: nil, target_user: nil, media: nil).destroy_all
    Post.only_deleted.where(user_id: id).delete_all
    # Reparent relationships to the "Deleted" user
    posts.update_all(user_id: -10)
    comments.update_all(user_id: -10)
    group_reports.update_all(user_id: -10)
    group_reports_as_moderator.update_all(moderator_id: -10)
    reports.update_all(user_id: -10)
    reports_as_moderator.update_all(moderator_id: -10)
    site_announcements.update_all(user_id: -10)
  end

  after_commit on: :create do
    # Send Confirmation Email
    UserMailer.confirmation(self).deliver_later

    # Set up feeds
    profile_feed.setup!
    timeline.setup!
    site_announcements_feed.setup!
    AnimeTimelineFeed.new(id).setup!
    MangaTimelineFeed.new(id).setup!
    DramaTimelineFeed.new(id).setup!

    # Automatically join "Kitsu" group
    GroupMember.create!(user: self, group: Group.kitsu) if Group.kitsu
  end

  after_save do
    if share_to_global_changed?
      if share_to_global
        GlobalFeed.new.follow(profile_feed)
      else
        GlobalFeed.new.unfollow(profile_feed)
      end
    end
  end

  after_create do
    # Set up Notification Settings for User
    NotificationSetting.setup!(self)
  end

  before_update do
    if name_changed?
      # Push it onto the front and limit
      self.past_names = [name_was, *past_names].first(PAST_NAMES_LIMIT)
    end
    self.previous_email = nil if confirmed_at_changed?
    if email_changed? && !Rails.env.staging?
      self.previous_email = email_was
      self.confirmed_at = nil
      UserMailer.confirmation(self).deliver_later
    end
    update_profile_completed
    update_feed_completed
  end
end
