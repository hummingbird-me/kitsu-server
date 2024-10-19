# frozen_string_literal: true

class Post < ApplicationRecord
  include WithActivity
  include ContentProcessable
  include ContentEmbeddable
  WordfilterCallbacks.hook(self, :post, :content)

  acts_as_paranoid
  resourcify
  processable :content, LongPipeline
  embed_links_in :content, to: :embed

  enum locked_reason: { spam: 0, too_heated: 1, closed: 2 }
  belongs_to :user
  belongs_to :edited_by, class_name: 'User', optional: true
  belongs_to :target_user, class_name: 'User', optional: true
  belongs_to :target_group, class_name: 'Group', optional: true
  belongs_to :media, polymorphic: true, optional: true
  belongs_to :spoiled_unit, polymorphic: true, optional: true
  belongs_to :community_recommendation, optional: true
  belongs_to :locked_by, class_name: 'User', optional: true
  has_many :post_likes, dependent: :destroy
  has_many :post_follows, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :uploads, as: 'owner', dependent: :destroy
  has_one :ama, foreign_key: 'original_post_id'
  has_one :pinner, class_name: 'User', foreign_key: 'pinned_post_id', dependent: :nullify
  has_many :reposts, dependent: :delete_all

  scope :sfw, -> { where(nsfw: false) }
  scope :in_group, ->(group) { where(target_group: group) }
  scope :visible_for, ->(user) {
    where(target_group_id: Group.visible_for(user))
      .or(where(target_group_id: nil))
      .where(hidden_at: nil)
      .or(where(user_id: user).where.not(hidden_at: nil))
  }

  validates :content, :content_formatted, presence: true, unless: :uploads
  validates :uploads, presence: true, unless: :content
  validates :media, presence: true, if: :spoiled_unit
  validates :content, length: { maximum: 9_000 }
  validates :media, polymorphism: { type: Media }, allow_blank: true
  # posting to a group, posting to a profile, and posting to an interest are mutually exclusive.
  validates_with ExclusivityValidator, over: %i[target_user target_group target_interest]
  validates_with ExclusivityValidator, over: %i[uploads embed]
  validates :target_user, absence: true, if: :target_group
  validates :spoiled_unit, unit_in_media: true

  def feed
    PostFeed.new(id)
  end

  def comments_feed
    PostCommentsFeed.new(id)
  end

  def other_feeds
    feeds = []
    feeds << GlobalFeed.new if user.share_to_global? && target_user.blank? && target_group.blank?
    # Limit media-feed fanout when targeting a unit
    feeds << (spoiled_unit ? media&.feed&.no_fanout : media&.feed)
    feeds << spoiled_unit&.feed
    feeds.compact
  end

  def notified_feeds
    [
      target_user&.notifications,
      *mentioned_users.map(&:notifications)
    ].compact - [user.notifications]
  end

  def target_feed
    if target_user # A => B, post to B without fanout
      target_user.profile_feed.no_fanout
    elsif target_group # A => Group, post to Group
      target_group.feed
    else # General post, fanout normally
      user.profile_feed
    end
  end

  def target_timelines
    return [] unless target_user
    [user.timeline, target_user.timeline]
  end

  def stream_activity
    target_feed.activities.new(
      post_id: id,
      updated_at:,
      post_likes_count:,
      comments_count:,
      nsfw:,
      mentioned_users: mentioned_users.pluck(:id),
      to: other_feeds + notified_feeds + target_timelines
    )
  end

  def mentioned_users
    User.where(id: processed_content[:mentioned_users])
  end

  def locked?
    locked_by.present?
  end

  before_save do
    # Always check if the media is NSFW and try to force into NSFWness
    self.nsfw = media.try(:nsfw?) || false unless nsfw
    self.nsfw = target_group.try(:nsfw?) || false unless nsfw
    true
  end

  before_update do
    if content_changed? || nsfw_changed? || spoiler?
      self.edited_at = Time.now
      self.edited_by = User.current
    end
    true
  end

  after_create do
    User.increment_counter(:posts_count, user.id) unless user.posts_count >= 20
    media.trending_vote(user, 2.0) if media.present?
    GroupUnreadFanoutWorker.perform_async(target_group_id, user_id) if target_group.present?
    if community_recommendation.present?
      CommunityRecommendationReasonWorker.perform_async(self, community_recommendation)
    end
  end

  before_destroy do
    deletions = reposts.pluck(:user_id, :id).map do |user_id, repost_id|
      [['user', user_id], { foreign_id: "repost:#{repost_id}" }]
    end
    ActivityDeletionWorker.perform_async(deletions)
  end
end
