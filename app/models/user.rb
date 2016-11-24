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
#  avatar_processing           :boolean
#  avatar_updated_at           :datetime
#  bio                         :string(140)      default(""), not null
#  birthday                    :date
#  comments_count              :integer          default(0), not null
#  confirmed_at                :datetime
#  cover_image_content_type    :string(255)
#  cover_image_file_name       :string(255)
#  cover_image_file_size       :integer
#  cover_image_updated_at      :datetime
#  current_sign_in_at          :datetime
#  dropbox_secret              :string(255)
#  dropbox_token               :string(255)
#  email                       :string(255)      default(""), not null, indexed
#  favorites_count             :integer          default(0), not null
#  followers_count             :integer          default(0)
#  following_count             :integer          default(0)
#  gender                      :string
#  import_error                :string(255)
#  import_from                 :string(255)
#  import_status               :integer
#  ip_addresses                :inet             default([]), is an Array
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
#  onboarded                   :boolean          default(FALSE), not null
#  password_digest             :string(255)      default(""), not null
#  past_names                  :string           default([]), not null, is an Array
#  posts_count                 :integer          default(0), not null
#  pro_expires_at              :datetime
#  ratings_count               :integer          default(0), not null
#  recommendations_up_to_date  :boolean
#  rejected_edit_count         :integer          default(0)
#  remember_created_at         :datetime
#  reviews_count               :integer          default(0), not null
#  sfw_filter                  :boolean          default(TRUE)
#  sign_in_count               :integer          default(0)
#  stripe_token                :string(255)
#  subscribed_to_newsletter    :boolean          default(TRUE)
#  title_language_preference   :string(255)      default("canonical")
#  to_follow                   :boolean          default(FALSE), indexed
#  unconfirmed_email           :string(255)
#  waifu_or_husbando           :string(255)
#  website                     :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  facebook_id                 :string(255)      indexed
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
# rubocop:enable Metrics/LineLength

class User < ApplicationRecord
  PAST_NAMES_LIMIT = 10
  PAST_IPS_LIMIT = 20

  rolify
  has_secure_password

  belongs_to :pro_membership_plan, required: false
  belongs_to :waifu, required: false, class_name: 'Character'
  has_many :followers, class_name: 'Follow', foreign_key: 'followed_id',
    dependent: :destroy
  has_many :following, class_name: 'Follow', foreign_key: 'follower_id',
    dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :media_follows, dependent: :destroy
  has_many :blocks, dependent: :destroy
  has_many :linked_profiles, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :library_entries, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :comment_likes, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  has_many :review_likes, dependent: :destroy
  has_many :list_imports, dependent: :destroy

  has_attached_file :avatar
  has_attached_file :cover_image

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true
  validates :facebook_id, uniqueness: true, allow_nil: true
  validates_attachment :avatar, content_type: {
    content_type: %w[image/jpg image/jpeg image/png image/gif]
  }
  validates_attachment :cover_image, content_type: {
    content_type: %w[image/jpg image/jpeg image/png image/gif]
  }

  scope :by_name, -> (*names) {
    where('lower(name) IN (?)', names.flatten.map(&:downcase))
  }

  # TODO: I think Devise can handle this for us
  def self.find_for_auth(identification)
    identification = [identification.downcase]
    where('lower(email)=? OR lower(name)=?', *(identification * 2)).first
  end

  def pro?
    return false if pro_expires_at.nil?
    pro_expires_at >= Time.now
  end

  def previous_name
    past_names.first
  end

  def add_ip(new_ip)
    unless ip_addresses.include?(new_ip)
      ips = [new_ip, *ip_addresses].compact.first(PAST_IPS_LIMIT)
      update!(ip_addresses: ips)
    end
    ip_addresses
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

  after_create do
    aggregated_feed.follow(feed)
    timeline.follow(feed)
    Feed.global.follow(feed)
  end

  before_update do
    if name_changed?
      # Push it onto the front and limit
      self.past_names = [name_was, *past_names].first(PAST_NAMES_LIMIT)
    end
  end
end
