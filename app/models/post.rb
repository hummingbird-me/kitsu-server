# rubocop:disable Metrics/LineLength
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
#  fk_rails_43023491e6  (target_user_id => users.id)
#  fk_rails_5b5ddfd518  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require_dependency 'html/pipeline/onebox_filter'

class Post < ApplicationRecord
  include WithActivity
  include ContentProcessable

  acts_as_paranoid
  resourcify
  processable :content, LongPipeline

  belongs_to :user, required: true, counter_cache: true
  belongs_to :target_user, class_name: 'User'
  belongs_to :target_group, class_name: 'Group'
  belongs_to :media, polymorphic: true
  belongs_to :spoiled_unit, polymorphic: true
  has_many :post_likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  scope :in_group, ->(group) { where(target_group: group) }

  validates :content, :content_formatted, presence: true
  validates :media, presence: true, if: :spoiled_unit
  validates :spoiler, acceptance: {
    accept: true,
    message: 'must be true if spoiled_unit is provided'
  }, if: :spoiled_unit
  validates :content, length: { maximum: 9_000 }
  validates :media, polymorphism: { type: Media }, allow_blank: true
  validates :target_user, absence: true, if: :target_group

  def feed
    Feed.post(id)
  end

  def other_feeds
    [media&.posts_feed].compact
  end

  def notified_feeds
    [
      target_user&.notifications,
      *mentioned_users.map(&:notifications)
    ].compact - [user.notifications]
  end

  def target_feed
    if target_user
      target_user.posts_aggregated_feed
    elsif target_group
      target_group.feed
    else
      user.posts_feed
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
      to: other_feeds + notified_feeds + target_timelines
    )
  end

  def mentioned_users
    User.by_name(processed_content[:mentioned_usernames])
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
    if target_group.present?
      GroupUnreadFanoutWorker.perform_async(target_group_id, user_id)
    end
  end
end
