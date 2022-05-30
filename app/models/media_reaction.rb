class MediaReaction < ApplicationRecord
  include WithActivity
  WordfilterCallbacks.hook(self, :reaction, :reaction)

  acts_as_paranoid

  belongs_to :user, optional: false, counter_cache: true
  belongs_to :media, polymorphic: true, optional: false
  belongs_to :anime, optional: true
  belongs_to :manga, optional: true
  belongs_to :drama, optional: true
  belongs_to :library_entry, optional: false
  has_many :votes, class_name: 'MediaReactionVote', dependent: :destroy

  validates :media_id, uniqueness: { scope: %i[user_id media_type] }, unless: :deleted?
  validates :media, polymorphism: { type: Media }
  validates :reaction, length: { maximum: 140 }, allow_blank: false

  resourcify

  before_validation do
    self.media = retrieve_media
    self.progress = library_entry&.progress
  end

  before_update do
    votes.destroy_all if reaction_changed?
  end

  def stream_activity
    user.profile_feed.activities.new(
      progress: progress,
      updated_at: updated_at,
      up_votes_count: up_votes_count,
      to: [media.feed, GlobalFeed.new]
    )
  end

  def retrieve_media
    if anime.present?
      anime
    elsif manga.present?
      manga
    elsif drama.present?
      drama
    end
  end

  def deleted?
    deleted_at.present?
  end

  def reaction=(value)
    super(value&.strip)
  end
end
