class Comment < ApplicationRecord
  include WithActivity
  include ContentProcessable
  include ContentEmbeddable
  WordfilterCallbacks.hook(self, :comment, :content)

  acts_as_paranoid
  resourcify
  counter_culture :post, column_name: ->(model) {
    'top_level_comments_count' if model.parent.blank?
  }, execute_after_commit: true
  processable :content, LongPipeline
  embed_links_in :content, to: :embed

  belongs_to :user, optional: false
  belongs_to :post, optional: false, counter_cache: true, touch: true
  belongs_to :parent, class_name: 'Comment', optional: true,
    counter_cache: 'replies_count', touch: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id',
    dependent: :destroy
  has_many :likes, class_name: 'CommentLike', dependent: :destroy
  has_many :uploads, as: 'owner', dependent: :destroy

  scope :in_group, ->(group) { joins(:post).merge(Post.in_group(group)) }

  validate :no_grandparents
  validates :content, :content_formatted, presence: true, unless: :uploads
  validates :uploads, presence: true, unless: :content
  validates :content, length: { maximum: 9_000 }
  validates :post, active_ama: {
    message: 'cannot make any more comments on this AMA',
    user: :user
  }

  def stream_activity
    to = []
    to << post.user.notifications unless post.user == user
    to << parent&.user&.notifications unless parent&.user == user
    to += mentioned_users.map(&:notifications)
    if bump?
      to += post.other_feeds
      to += post.target_timelines
      to << post.target_feed
    end
    to << post.comments_feed
    to.compact!
    post.feed.activities.new(
      reply_to_user: (parent&.user || post&.user),
      reply_to_type: (parent.present? ? 'comment' : 'post'),
      likes_count: likes_count,
      replies_count: replies_count,
      post_id: post_id,
      target: post,
      mentioned_users: mentioned_users.pluck(:id),
      to: to - [user.notifications]
    )
  end

  # Should we bump the Post we're replying to?
  # @return [Boolean] whether to bump
  def bump?
    # No bumping for subcomments
    return false if parent.present?
    # No bumping for posts older than 2 weeks
    return false if post.created_at < 14.days.ago
    # Only bump for 25% of comments on Kitsu-group posts
    return rand <= 0.25 if Group.kitsu && post.target_group_id == Group.kitsu.id
    # Otherwise yeah, bump away my dude
    true
  end

  def mentioned_users
    User.where(id: processed_content[:mentioned_users])
  end

  def no_grandparents
    errors.add(:parent, 'cannot have a parent of their own') if parent&.parent
  end

  before_update do
    self.edited_at = Time.now if content_changed?
    true
  end
  after_create do
    unless user.feed_completed?
      User.increment_counter(:comments_count, user.id)
      user.update_feed_completed!
    end
    # PostFollow.create(user: user, post: post)
  end
end
