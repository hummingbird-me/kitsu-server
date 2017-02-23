# == Schema Information
#
# Table name: reviews
#
#  id                :integer          not null, primary key
#  content           :text             not null
#  content_formatted :text             not null
#  deleted_at        :datetime         indexed
#  likes_count       :integer          default(0), indexed
#  media_type        :string
#  progress          :integer
#  rating            :float            not null
#  source            :string(255)
#  spoiler           :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  library_entry_id  :integer
#  media_id          :integer          not null, indexed
#  user_id           :integer          not null, indexed
#
# Indexes
#
#  index_reviews_on_deleted_at   (deleted_at)
#  index_reviews_on_likes_count  (likes_count)
#  index_reviews_on_media_id     (media_id)
#  index_reviews_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_150e554f22  (library_entry_id => library_entries.id)
#

class Review < ApplicationRecord
  has_paper_trail
  include WithActivity
  include ContentProcessable

  acts_as_paranoid

  has_many :likes, class_name: 'ReviewLike', dependent: :destroy
  belongs_to :media, polymorphic: true, required: true
  belongs_to :user, required: true, counter_cache: true
  belongs_to :library_entry, required: true

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
    user.feed.activities.new(
      progress: progress,
      updated_at: updated_at,
      likes_count: likes_count,
      to: [media.feed]
    )
  end
end
