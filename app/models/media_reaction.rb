# frozen_string_literal: true

class MediaReaction < ApplicationRecord
  include WithActivity
  include WithStory

  WordfilterCallbacks.hook(self, :reaction, :reaction)

  acts_as_paranoid

  belongs_to :user, counter_cache: true
  belongs_to :media, polymorphic: true
  belongs_to :anime, optional: true
  belongs_to :manga, optional: true
  belongs_to :drama, optional: true
  belongs_to :library_entry
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

  with_story do
    Story::MediaReactionStory.new(
      data: {
        media_reaction_id: self.id
      }
    )
  end

  def stream_activity
    user.profile_feed.activities.new(
      progress:,
      updated_at:,
      up_votes_count:,
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
