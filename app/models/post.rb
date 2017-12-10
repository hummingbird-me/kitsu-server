# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: posts
#
#  id                          :integer          not null, primary key
#  blocked                     :boolean          default(FALSE), not null
#  comments_count              :integer          default(0), not null
#  content                     :text
#  content_formatted           :text
#  deleted_at                  :datetime         indexed
#  edited_at                   :datetime
#  embed                       :jsonb
#  media_type                  :string           indexed => [media_id]
#  nsfw                        :boolean          default(FALSE), not null
#  post_likes_count            :integer          default(0), not null
#  spoiled_unit_type           :string
#  spoiler                     :boolean          default(FALSE), not null
#  target_interest             :string
#  top_level_comments_count    :integer          default(0), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  community_recommendation_id :integer          indexed
#  media_id                    :integer          indexed => [media_type]
#  spoiled_unit_id             :integer
#  target_group_id             :integer
#  target_user_id              :integer
#  user_id                     :integer          not null
#
# Indexes
#
#  index_posts_on_community_recommendation_id  (community_recommendation_id)
#  index_posts_on_deleted_at                   (deleted_at)
#  posts_media_type_media_id_idx               (media_type,media_id)
#
# Foreign Keys
#
#  fk_rails_5b5ddfd518  (user_id => users.id)
#  fk_rails_6fac2de613  (target_user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require_dependency 'html/pipeline/onebox_filter'

class Post < ApplicationRecord
  include WithActivity
  include ContentProcessable
  include ContentEmbeddable

  acts_as_paranoid
  resourcify
  processable :content, LongPipeline
  update_algolia 'AlgoliaPostsIndex'
  embed_links_in :content, to: :embed

  belongs_to :user, required: true, counter_cache: true
  belongs_to :target_user, class_name: 'User'
  belongs_to :target_group, class_name: 'Group'
  belongs_to :media, polymorphic: true
  belongs_to :spoiled_unit, polymorphic: true
  belongs_to :community_recommendation
  has_many :post_likes, dependent: :destroy
  has_many :post_follows, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :uploads, as: 'owner', dependent: :destroy
  has_one :ama, foreign_key: 'original_post_id'
  has_many :reposts, dependent: :delete_all

  scope :sfw, -> { where(nsfw: false) }
  scope :in_group, ->(group) { where(target_group: group) }
  scope :visible_for, ->(user) {
    where(target_group_id: Group.visible_for(user)).or(where(target_group_id: nil))
  }

  validates :content, :content_formatted, presence: true, unless: :uploads
  validates :uploads, presence: true, unless: :content
  validates :media, presence: true, if: :spoiled_unit
  validates :content, length: { maximum: 9_000 }
  validates :media, polymorphism: { type: Media }, allow_blank: true
  # posting to a group, posting to a profile, and posting to an interest are mutually exclusive.
  validates_with ExclusivityValidator, over: %i[target_user target_group target_interest]
  validates :target_user, absence: true, if: :target_group

  def feed
    PostFeed.new(id)
  end

  def comments_feed
    PostCommentsFeed.new(id)
  end

  def other_feeds
    feeds = []
    feeds << InterestGlobalFeed.new(target_interest) if target_interest
    # Don't fan out beyond aggregated feed
    feeds << media&.feed&.no_fanout
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
      updated_at: updated_at,
      post_likes_count: post_likes_count,
      comments_count: comments_count,
      nsfw: nsfw,
      mentioned_users: mentioned_users.pluck(:id),
      to: other_feeds + notified_feeds + target_timelines
    )
  end

  def mentioned_users
    User.by_slug(processed_content[:mentioned_usernames])
  end

  before_save do
    # Always check if the media is NSFW and try to force into NSFWness
    self.nsfw = media.try(:nsfw?) || false unless nsfw
    self.nsfw = target_group.try(:nsfw?) || false unless nsfw
    true
  end

  before_update do
    self.edited_at = Time.now if content_changed?
    true
  end

  after_create do
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
