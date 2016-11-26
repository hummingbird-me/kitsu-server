# == Schema Information
#
# Table name: reviews
#
#  id                :integer          not null, primary key
#  content           :text             not null
#  content_formatted :text             not null
#  legacy            :boolean          default(FALSE), not null
#  likes_count       :integer          default(0)
#  media_type        :string
#  progress          :integer
#  rating            :integer          not null
#  source            :string(255)
#  summary           :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  library_entry_id  :integer
#  media_id          :integer          not null, indexed
#  user_id           :integer          not null, indexed
#
# Indexes
#
#  index_reviews_on_media_id  (media_id)
#  index_reviews_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_150e554f22  (library_entry_id => library_entries.id)
#

class Review < ApplicationRecord
  include WithActivity

  has_many :likes, class_name: 'ReviewLike', dependent: :destroy
  belongs_to :media, polymorphic: true, required: true
  belongs_to :user, required: true, counter_cache: true
  belongs_to :library_entry, required: true

  validates :content, presence: true
  validates :rating, presence: true
  validates :summary, absence: true, unless: :legacy?
  validates :summary, presence: true, if: :legacy?
  validates :media_id, uniqueness: { scope: :user_id }

  resourcify

  def processed_content
    @processed_content ||= InlinePipeline.call(content)
  end

  before_validation do
    self.source ||= 'hummingbird'
    self.progress = library_entry&.progress
    self.rating = library_entry&.rating
    if content_changed?
      self.content_formatted = processed_content[:output].to_s
    end
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
