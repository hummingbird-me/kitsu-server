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
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_id         :integer
#  post_id           :integer          not null
#  user_id           :integer          not null
#
# Foreign Keys
#
#  fk_rails_03de2dc08c  (user_id => users.id)
#  fk_rails_2fd19c0db7  (post_id => posts.id)
#  fk_rails_31554e7034  (parent_id => comments.id)
#
# rubocop:enable Metrics/LineLength

class Comment < ApplicationRecord
  include WithActivity

  belongs_to :user, required: true
  belongs_to :post, required: true, counter_cache: true
  belongs_to :parent, class_name: 'Comment', required: false
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id',
    dependent: :destroy
  has_many :likes, class_name: 'CommentLike', dependent: :destroy

  validates :content, :content_formatted, presence: true
  validate :no_grandparents
  validates :content, length: { maximum: 9_000 }

  def stream_activity
    post.feed.activities.new(
      likes_count: likes_count
    )
  end

  def no_grandparents
    errors.add(:parent, 'cannot have a parent of their own') if parent&.parent
  end

  before_validation do
    if content_changed?
      self.content_formatted = InlinePipeline.call(content)[:output].to_s
    end
  end
end
