# == Schema Information
#
# Table name: media_reactions
#
#  id               :integer          not null, primary key
#  media_type       :string           not null, indexed => [media_id, user_id]
#  progress         :integer          default(0), not null
#  reaction         :string(140)
#  up_votes_count   :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  library_entry_id :integer          indexed
#  media_id         :integer          not null, indexed => [media_type, user_id]
#  user_id          :integer          indexed => [media_type, media_id], indexed
#
# Indexes
#
#  index_media_reactions_on_library_entry_id                     (library_entry_id)
#  index_media_reactions_on_media_type_and_media_id_and_user_id  (media_type,media_id,user_id) UNIQUE
#  index_media_reactions_on_user_id                              (user_id)
#
# Foreign Keys
#
#  fk_rails_08b3ced6d4  (user_id => users.id)
#  fk_rails_bbc29d526d  (library_entry_id => library_entries.id)
#

class MediaReaction < ActiveRecord::Base
  include WithActivity

  belongs_to :user, required: true
  belongs_to :media, polymorphic: true, required: true
  belongs_to :library_entry, required: true
  has_many :votes, class_name: 'MediaReactionVote', dependent: :destroy

  validates :media_id, uniqueness: { scope: :user_id }
  validates :media, polymorphism: { type: Media }
  validates :reaction, length: { maximum: 140 }, allow_nil: false

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
