# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: comments
#
#  id                :integer          not null, primary key
#  blocked           :boolean          default(FALSE), not null
#  content           :text             not null
#  content_formatted :text             not null
#  deleted_at        :datetime
#  likes_count       :integer          default(0), not null
#  replies_count     :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_id         :integer
#  post_id           :integer          not null
#  user_id           :integer          not null
#
# Foreign Keys
#
#  fk_rails_31554e7034  (parent_id => comments.id)
#
# rubocop:enable Metrics/LineLength

class Comment < ApplicationRecord
  include WithActivity
  include ContentProcessable

  acts_as_paranoid
  resourcify
  counter_culture :post, column_name: -> (model) {
    'top_level_comments_count' if model.parent.blank?
  }
  processable :content, LongPipeline

  belongs_to :user, required: true, counter_cache: true
  belongs_to :post, required: true, counter_cache: true
  belongs_to :parent, class_name: 'Comment', required: false,
		counter_cache: 'replies_count'
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id',
    dependent: :destroy
  has_many :likes, class_name: 'CommentLike', dependent: :destroy

  validates :content, :content_formatted, presence: true
  validate :no_grandparents
  validates :content, length: { maximum: 9_000 }

  def stream_activity
    post.feed.activities.new(
      likes_count: likes_count,
      replies_count: replies_count,
      *mentioned_users.map(&:notifications)
    )
  end

  def mentioned_users
    User.by_name(processed_content[:mentioned_usernames])
  end

  def no_grandparents
    errors.add(:parent, 'cannot have a parent of their own') if parent&.parent
  end
end
