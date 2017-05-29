class MediaReaction < ActiveRecord::Base
  include WithActivity

  belongs_to :user, required: true
  belongs_to :media, polymorphic: true, required: true
  belongs_to :library_entry, required: true
  has_many :votes, class_name: 'MediaReactionVote', dependent: :destroy

  validates :media_id, uniqueness: { scope: :user_id }
  validates :media, polymorphism: { type: Media }
  validates :reaction, length: { maximum: 140 }, required: true

  resourcify

  before_validation do
    self.progress = library_entry&.progress
  end

  def stream_activity
    user.profile_feed.activities.new(
      progress: progress,
      updated_at: updated_at,
      up_votes_count: up_votes_count,
      to: [media.feed]
    )
  end
end
