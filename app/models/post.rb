# == Schema Information
#
# Table name: posts
#
#  id                       :integer          not null, primary key
#  blocked                  :boolean          default(FALSE), not null
#  comments_count           :integer          default(0), not null
#  content                  :text             not null
#  content_formatted        :text             not null
#  deleted_at               :datetime         indexed
#  edited_at                :datetime
#  media_type               :string
#  nsfw                     :boolean          default(FALSE), not null
#  post_likes_count         :integer          default(0), not null
#  spoiled_unit_type        :string
#  spoiler                  :boolean          default(FALSE), not null
#  top_level_comments_count :integer          default(0), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  media_id                 :integer
#  spoiled_unit_id          :integer
#  target_group_id          :integer
#  target_user_id           :integer
#  user_id                  :integer          not null
#
# Indexes
#
#  index_posts_on_deleted_at  (deleted_at)
#
# Foreign Keys
#
#  fk_rails_5b5ddfd518  (user_id => users.id)
#  fk_rails_6fac2de613  (target_user_id => users.id)
#

class Post < ApplicationRecord
  has_paper_trail
  include WithActivity
  include ContentProcessable

  acts_as_paranoid
  resourcify
  processable :content, LongPipeline

  belongs_to :user, required: true, counter_cache: true
  belongs_to :target_user, class_name: 'User'
  belongs_to :media, polymorphic: true
  belongs_to :spoiled_unit, polymorphic: true
  has_many :post_likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :content, :content_formatted, presence: true
  validates :media, presence: true, if: :spoiled_unit
  validates :spoiler, acceptance: {
    accept: true,
    message: 'must be true if spoiled_unit is provided'
  }, if: :spoiled_unit
  validates :content, length: { maximum: 9_000 }
  validates :media, polymorphism: { type: Media }, allow_blank: true

  def feed
    Feed.post(id)
  end

  def stream_feeds
    [
      media&.feed,
      target_user&.feed,
    ].compact
  end

  def stream_notified
    [
      target_user&.notifications,
      *mentioned_users.map(&:notifications)
    ].compact - [user.notifications]
  end

  def stream_activity
    user.feed.activities.new(
      post_id: id,
      updated_at: updated_at,
      post_likes_count: post_likes_count,
      comments_count: comments_count,
      nsfw: nsfw,
      to: stream_feeds + stream_notified
    )
  end

  def mentioned_users
    User.by_name(processed_content[:mentioned_usernames])
  end

  before_save do
    # Always check if the media is NSFW and try to force into NSFWness
    self.nsfw = media.try(:nsfw?) || false unless nsfw
    true
  end

  before_update do
    self.edited_at = Time.now if content_changed?
    true
  end

  after_create do
    media.trending_vote(user, 2.0) if media.present?
  end
end
