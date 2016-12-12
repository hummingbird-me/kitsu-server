# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: library_entries
#
#  id              :integer          not null, primary key
#  media_type      :string           not null, indexed => [user_id], indexed => [user_id, media_id]
#  notes           :text
#  nsfw            :boolean          default(FALSE), not null
#  private         :boolean          default(FALSE), not null, indexed
#  progress        :integer          default(0), not null
#  rating          :decimal(2, 1)
#  reconsume_count :integer          default(0), not null
#  reconsuming     :boolean          default(FALSE), not null
#  status          :integer          not null, indexed => [user_id]
#  volumes_owned   :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  media_id        :integer          not null, indexed => [user_id, media_type]
#  user_id         :integer          not null, indexed, indexed => [media_type], indexed => [media_type, media_id], indexed => [status]
#
# Indexes
#
#  index_library_entries_on_private                              (private)
#  index_library_entries_on_user_id                              (user_id)
#  index_library_entries_on_user_id_and_media_type               (user_id,media_type)
#  index_library_entries_on_user_id_and_media_type_and_media_id  (user_id,media_type,media_id) UNIQUE
#  index_library_entries_on_user_id_and_status                   (user_id,status)
#
# rubocop:enable Metrics/LineLength

class LibraryEntry < ApplicationRecord
  # TODO: apply this globally so that we can easily update it to add the
  # totally definitely happening 1000-point scale.  Or just because it's good
  # practice.
  VALID_RATINGS = (0.5..5).step(0.5).to_a.freeze

  belongs_to :user, touch: true
  belongs_to :media, polymorphic: true, counter_cache: 'user_count'
  has_one :review, dependent: :destroy
  has_many :marathons, dependent: :destroy

  scope :sfw, -> { where(nsfw: false) }

  enum status: {
    current: 1,
    planned: 2,
    completed: 3,
    on_hold: 4,
    dropped: 5
  }
  attr_accessor :imported

  validates :user, :media, :status, :progress, :reconsume_count,
    presence: true
  validates :media, polymorphism: { type: Media }
  validates :user_id, uniqueness: { scope: %i[media_type media_id] }
  validates :rating, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 5
  }, allow_blank: true
  validates :reconsume_count, numericality: {
    less_than_or_equal_to: 50,
    message: 'just... go outside'
  }
  validate :progress_limit
  validate :rating_on_halves

  counter_culture :user, column_name: -> (le) { 'ratings_count' if le.rating }

  def current_marathon
    marathons.current.first_or_create
  end

  def progress_limit
    return unless progress
    progress_cap = media&.progress_limit
    default_cap = media&.default_progress_limit

    if progress_cap && progress_cap != 0
      if progress > progress_cap
        errors.add(:progress, 'cannot exceed length of media')
      end
    elsif default_cap && progress > default_cap
      errors.add(:progress, 'is rather unreasonably high')
    end
  end

  def unit
    media.unit(progress)
  end

  def next_unit
    media.unit(progress + 1)
  end

  def rating_on_halves
    return unless rating

    errors.add(:rating, 'must be a multiple of 0.5') unless rating % 0.5 == 0.0
  end

  def activity
    MediaActivityService.new(self)
  end

  before_save do
    if status_changed? && completed? && media.progress_limit
      # When marked completed, we try to update progress to the cap
      self.progress = media.progress_limit
    elsif progress == media.progress_limit
      # When in current and progress equals total episodes
      self.status = :completed
    elsif progress != media.progress_limit && completed?
      # When in completed and episodes changed, strange case
      self.status = :current
    end
  end

  after_save do
    # Disable activities on import
    unless imported
      activity.rating(rating)&.create if rating_changed?
      activity.status(status)&.create if status_changed?
      # If the progress has changed, make an activity unless the status is also
      # changing
      if progress_changed? && !status_changed?
        activity.progress(progress)&.create
      end
    end

    if rating_changed?
      media.transaction do
        media.decrement_rating_frequency(rating_was)
        media.increment_rating_frequency(rating)
      end
    end
  end
end
