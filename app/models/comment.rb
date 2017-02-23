# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: comments
#
#  id                :integer          not null, primary key
#  blocked           :boolean          default(FALSE), not null
#  content           :text             not null
#  content_formatted :text             not null
#  deleted_at        :datetime         indexed
#  edited_at         :datetime
#  likes_count       :integer          default(0), not null
#  replies_count     :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_id         :integer          indexed
#  post_id           :integer          not null, indexed
#  user_id           :integer          not null
#
# Indexes
#
#  index_comments_on_deleted_at  (deleted_at)
#  index_comments_on_parent_id   (parent_id)
#  index_comments_on_post_id     (post_id)
#
# Foreign Keys
#
#  fk_rails_31554e7034  (parent_id => comments.id)
#
# rubocop:enable Metrics/LineLength

class Comment < ApplicationRecord
  has_paper_trail
  include WithActivity
  include ContentProcessable

  acts_as_paranoid
  resourcify
  counter_culture :post, column_name: ->(model) {
    'top_level_comments_count' if model.parent.blank?
  }
  processable :content, LongPipeline

  belongs_to :user, required: true, counter_cache: true
  belongs_to :post, required: true, counter_cache: true, touch: true
  belongs_to :parent, class_name: 'Comment', required: false,
                      counter_cache: 'replies_count', touch: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id',
                     dependent: :destroy
  has_many :likes, class_name: 'CommentLike', dependent: :destroy

  validates :content, :content_formatted, presence: true
  validate :no_grandparents
  validates :content, length: { maximum: 9_000 }

  def stream_activity
    to = []
    to << post.user.notifications unless post.user == user
    to << parent&.user&.notifications unless parent&.user == user
    to += mentioned_users.map(&:notifications)
    to += post.stream_feeds
    to << post.user.feed
    to.compact!
    post.feed.activities.new(
      reply_to_user: (parent&.user || post&.user),
      reply_to_type: (parent.present? ? 'comment' : 'post'),
      likes_count: likes_count,
      replies_count: replies_count,
      post_id: post_id,
      target: post,
      to: to - [user.notifications]
    )
  end

  def mentioned_users
    User.by_name(processed_content[:mentioned_usernames])
  end

  def no_grandparents
    errors.add(:parent, 'cannot have a parent of their own') if parent&.parent
  end

  before_update do
    self.edited_at = Time.now if content_changed?
    true
  end

  after_create { user.update_feed_completed! }
end
