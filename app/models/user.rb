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
#  cover_image_processing      :boolean
#  cover_image_updated_at      :datetime
#  current_sign_in_at          :datetime
#  dropbox_secret              :string(255)
#  dropbox_token               :string(255)
#  email                       :string(255)      default(""), not null, indexed
#  favorites_count             :integer          default(0), not null
#  feed_completed              :boolean          default(FALSE), not null
#  followers_count             :integer          default(0)
#  following_count             :integer          default(0)
#  gender                      :string
#  import_error                :string(255)
#  import_from                 :string(255)
#  import_status               :integer
#  ip_addresses                :inet             default([]), is an Array
#  language                    :string
#  last_backup                 :datetime
#  last_recommendations_update :datetime
#  last_sign_in_at             :datetime
#  life_spent_on_anime         :integer          default(0), not null
#  likes_given_count           :integer          default(0), not null
#  likes_received_count        :integer          default(0), not null
#  location                    :string(255)
#  mal_username                :string(255)
#  name                        :string(255)
#  ninja_banned                :boolean          default(FALSE)
#  password_digest             :string(255)      default(""), not null
#  past_names                  :string           default([]), not null, is an Array
#  posts_count                 :integer          default(0), not null
#  previous_email              :string
#  pro_expires_at              :datetime
#  profile_completed           :boolean          default(FALSE), not null
#  ratings_count               :integer          default(0), not null
#  recommendations_up_to_date  :boolean
#  rejected_edit_count         :integer          default(0)
#  remember_created_at         :datetime
#  reviews_count               :integer          default(0), not null
#  sfw_filter                  :boolean          default(TRUE)
#  share_to_global             :boolean          default(TRUE), not null
#  sign_in_count               :integer          default(0)
#  stripe_token                :string(255)
#  subscribed_to_newsletter    :boolean          default(TRUE)
#  time_zone                   :string
#  title                       :string
#  title_language_preference   :string(255)      default("canonical")
#  to_follow                   :boolean          default(FALSE), indexed
#  waifu_or_husbando           :string(255)
#  website                     :string(255)
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
#  index_users_on_to_follow    (to_follow)
#  index_users_on_waifu_id     (waifu_id)
#
# Foreign Keys
#
#  fk_rails_bc615464bf  (pinned_post_id => posts.id)
#

class User < ApplicationRecord
  has_paper_trail
  include WithCoverImage
  include WithAvatar

  PAST_NAMES_LIMIT = 10
  PAST_IPS_LIMIT = 20
  RESERVED_NAMES = %w[
    admin administrator connect dashboard developer developers edit favorites
    feature featured features feed follow followers following hummingbird index
    javascript json kitsu sysadmin sysadministrator system unfollow user users
    wiki you staff mod
  ].freeze

  rolify after_add: :update_title, after_remove: :update_title
  has_secure_password
  update_index('users#user') { self }

  belongs_to :pro_membership_plan, required: false
  belongs_to :waifu, required: false, class_name: 'Character'
  belongs_to :pinned_post, class_name: 'Post', required: false
  has_many :followers, class_name: 'Follow', foreign_key: 'followed_id',
                       dependent: :destroy
  has_many :following, class_name: 'Follow', foreign_key: 'follower_id',
                       dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :media_follows, dependent: :destroy
  has_many :blocks, dependent: :destroy
  has_many :blocked, class_name: 'Block', foreign_key: 'blocked_id',
                     dependent: :destroy
  has_many :linked_accounts, dependent: :destroy
  has_many :profile_links, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :library_entries, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :comment_likes, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  has_many :review_likes, dependent: :destroy
  has_many :list_imports, dependent: :destroy

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { minimum: 3, maximum: 20 },
                   format: {
                     with: /\A[_A-Za-z0-9]+\z/,
                     message: <<-EOF.squish
                       can only contain letters, numbers, and underscores.
                     EOF
                   }
  validates :name, format: {
    with: /\A[A-Za-z0-9]/,
    message: 'must begin with a letter or number'
  }
  validates :name, format: {
    without: /\A[0-9]*\z/,
    message: 'cannot be entirely numbers'
  }
  validate :not_reserved_username
  validates :about, length: { maximum: 500 }
  validates :gender, length: { maximum: 20 }
  validates :password_digest, presence: true
  validates :facebook_id, uniqueness: true, allow_nil: true

  scope :by_name, ->(*names) {
    where('lower(users.name) IN (?)', names.flatten.map(&:downcase))
  }
  scope :blocking, ->(*users) { where.not(id: users.flatten) }
  scope :alts_of, ->(user) do
    where('ip_addresses && ARRAY[?]::inet', user.ip_addresses)
  end

  # TODO: I think Devise can handle this for us
  def self.find_for_auth(identification)
    identification = [identification.downcase]
    where('lower(email)=? OR lower(name)=?', *(identification * 2)).first
  end

  def not_reserved_username
    errors.add(:name, 'is reserved') if RESERVED_NAMES.include?(name.downcase)
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

  def add_ip(new_ip)
    unless ip_addresses.include?(new_ip)
      ips = [new_ip, *ip_addresses].compact.first(PAST_IPS_LIMIT)
      update_attribute(:ip_addresses, ips)
    end
    ip_addresses
  end

  def alts
    User.alts_of(self)
  end

  def update_title(_role)
    if has_role?(:admin)
      update(title: 'Staff')
    elsif has_role?(:admin, Anime)
      update(title: 'Mod')
    end
  end

  def admin?
    self.title == 'Staff' || self.title == 'Mod'
  end

  def feed
    @feed ||= Feed.user(id)
  end

  def aggregated_feed
    @aggr_feed ||= Feed.user_aggr(id)
  end

  def timeline
    @timeline ||= Feed.timeline(id)
  end

  def notifications
    @notifications ||= Feed.notifications(id)
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

  after_create do
    UserMailer.confirmation(self).deliver_later
    aggregated_feed.follow(feed)
    timeline.follow(feed)
    Feed.global.follow(feed)
  end

  after_save do
    if share_to_global_changed?
      if share_to_global
        Feed.global.follow(feed)
      else
        Feed.global.unfollow(feed)
      end
    end
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
