class Review < ApplicationRecord
  include WithActivity
  include ContentProcessable

  acts_as_paranoid

  has_many :likes, class_name: 'ReviewLike', dependent: :destroy
  belongs_to :media, polymorphic: true, optional: false
  belongs_to :user, optional: false, counter_cache: true
  belongs_to :library_entry, optional: false

  validates :content, presence: true
  validates :rating, presence: true
  validates :media_id, uniqueness: { scope: :user_id }
  validates :media, polymorphism: { type: Media }

  resourcify
  processable :content, InlinePipeline

  before_validation do
    self.source ||= 'hummingbird'
    self.progress = library_entry&.progress
    self.rating = library_entry&.rating
  end

  def stream_activity
    user.profile_feed.activities.new(
      progress: progress,
      updated_at: updated_at,
      likes_count: likes_count,
      to: [media.feed]
    )
  end
end
