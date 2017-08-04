# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: media_reactions
#
#  id               :integer          not null, primary key
#  deleted_at       :datetime         indexed
#  media_type       :string           not null, indexed => [media_id, user_id]
#  progress         :integer          default(0), not null
#  reaction         :string(140)
#  up_votes_count   :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  anime_id         :integer          indexed
#  drama_id         :integer          indexed
#  library_entry_id :integer          indexed
#  manga_id         :integer          indexed
#  media_id         :integer          not null, indexed => [media_type, user_id]
#  user_id          :integer          indexed => [media_type, media_id], indexed
#
# Indexes
#
#  index_media_reactions_on_anime_id                             (anime_id)
#  index_media_reactions_on_deleted_at                           (deleted_at)
#  index_media_reactions_on_drama_id                             (drama_id)
#  index_media_reactions_on_library_entry_id                     (library_entry_id)
#  index_media_reactions_on_manga_id                             (manga_id)
#  index_media_reactions_on_media_type_and_media_id_and_user_id  (media_type,media_id,user_id) UNIQUE
#  index_media_reactions_on_user_id                              (user_id)
#
# Foreign Keys
#
#  fk_rails_08b3ced6d4  (user_id => users.id)
#  fk_rails_77e29e3c45  (drama_id => dramas.id)
#  fk_rails_9a5bef4caf  (manga_id => manga.id)
#  fk_rails_bbc29d526d  (library_entry_id => library_entries.id)
#  fk_rails_db814b132f  (anime_id => anime.id)
#
# rubocop:enable Metrics/LineLength

class MediaReaction < ApplicationRecord
  include WithActivity

  acts_as_paranoid

  belongs_to :user, required: true, counter_cache: true
  belongs_to :media, polymorphic: true, required: true
  belongs_to :anime
  belongs_to :manga
  belongs_to :drama
  belongs_to :library_entry, required: true
  has_many :votes, class_name: 'MediaReactionVote', dependent: :destroy

  validates :media_id, uniqueness: { scope: %i[user_id media_type] }, unless: 'deleted_at.present?'
  validates :media, polymorphism: { type: Media }
  validates :reaction, length: { maximum: 140 }, allow_nil: false

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
      to: [media.feed]
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
end
