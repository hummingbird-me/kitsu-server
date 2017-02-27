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
#  anime_id        :integer          indexed
#  drama_id        :integer          indexed
#  manga_id        :integer          indexed
#  media_id        :integer          not null, indexed => [user_id, media_type]
#  user_id         :integer          not null, indexed, indexed => [media_type], indexed => [media_type, media_id], indexed => [status]
#
# Indexes
#
#  index_library_entries_on_anime_id                             (anime_id)
#  index_library_entries_on_drama_id                             (drama_id)
#  index_library_entries_on_manga_id                             (manga_id)
#  index_library_entries_on_private                              (private)
#  index_library_entries_on_user_id                              (user_id)
#  index_library_entries_on_user_id_and_media_type               (user_id,media_type)
#  index_library_entries_on_user_id_and_media_type_and_media_id  (user_id,media_type,media_id) UNIQUE
#  index_library_entries_on_user_id_and_status                   (user_id,status)
#
# rubocop:enable Metrics/LineLength

class LibraryEntry < ApplicationRecord
  has_paper_trail
  VALID_RATINGS = (0.5..5).step(0.5).to_a.freeze
  MEDIA_ASSOCIATIONS = %i[anime manga drama].freeze

  belongs_to :user, touch: true
  belongs_to :media, polymorphic: true
  belongs_to :anime
  belongs_to :manga
  belongs_to :drama
  has_one :review, dependent: :destroy
  has_many :marathons, dependent: :destroy

  scope :sfw, -> { where(nsfw: false) }
  scope :by_kind, ->(*kinds) do
    t = arel_table
    columns = kinds.map { |k| t[:"#{k}_id"] }
    scope = columns.shift.not_eq(nil)
    columns.each do |col|
      scope = scope.or(col.not_eq(nil))
    end
    where(scope)
  end

  enum status: {
    current: 1,
    planned: 2,
    completed: 3,
    on_hold: 4,
    dropped: 5
  }
  attr_accessor :imported

  validates :user, :status, :progress, :reconsume_count, presence: true
  validates :media, polymorphism: { type: Media }, presence: true
  validates :anime_id, uniqueness: { scope: :user_id }, allow_nil: true
  validates :manga_id, uniqueness: { scope: :user_id }, allow_nil: true
  validates :drama_id, uniqueness: { scope: :user_id }, allow_nil: true
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
  validate :one_media_present

  counter_culture :user, column_name: ->(le) { 'ratings_count' if le.rating }
  scope :rated, -> { where.not(rating: nil) }
  scope :following, ->(user) do
    user_id = user.respond_to?(:id) ? user.id : user
    user_id = sanitize(user_id.to_i) # Juuuuuust to be safe
    follows = Follow.arel_table
    sql = follows.where(follows[:follower_id].eq(user_id)).project(:followed_id)
    where("user_id IN (#{sql.to_sql})")
  end

  def current_marathon
    marathons.current.first_or_create
  end

  def progress_limit
    return unless progress
    progress_cap = media&.progress_limit
    default_cap = [media&.default_progress_limit, 50].compact.max

    if progress_cap&.nonzero?
      if progress > progress_cap
        errors.add(:progress, 'cannot exceed length of media')
      end
    elsif default_cap && progress > default_cap
      errors.add(:progress, 'is rather unreasonably high')
    end
  end

  def one_media_present
    media_present = MEDIA_ASSOCIATIONS.select { |col| send(col).present? }
    return if media_present.count == 1
    media_present.each do |col|
      errors.add(col, 'must have exactly one media present')
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

  def kind
    if anime.present?
      :anime
    elsif manga.present?
      :manga
    elsif drama.present?
      :drama
    end
  end

  def sync_to_mal?
    return unless media_type.in? %w[Anime Manga]

    User.find(user_id).linked_accounts.where(
      sync_to: true,
      type: 'LinkedAccount::MyAnimeList'
    ).present?
  end

  before_validation do
    # TEMPORARY: If media is set, copy it to kind_id, otherwise if kind_id is
    # set, copy it to media!
    if kind && send(kind).present?
      self.media = send(kind)
    else
      kind = media_type&.underscore
      send("#{kind}=", media) if kind
    end
  end

  before_save do
    if status_changed? && completed? && media&.progress_limit
      # When marked completed, we try to update progress to the cap
      self.progress = media.progress_limit
    elsif !status_changed? && progress == media&.progress_limit
      # When in current and progress equals total episodes
      self.status = :completed
    end
  end

  after_save do
    # Disable activities on import
    unless imported || private?
      activity.rating(rating)&.create if rating_changed? && rating.present?
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
      user.update_feed_completed!
      user.update_profile_completed!
    end

    media.trending_vote(user, 0.5) if progress_changed?
    media.trending_vote(user, 1.0) if status_changed?
  end

  # TODO: will rename this if I think of a better one
  after_commit :sync_entry_update, on: %i[create update]

  def sync_entry_update
    return unless sync_to_mal?

    MyAnimeListSyncWorker.perform_async(
      library_entry_id: id,
      method: 'create/update'
    )
  end

  after_destroy do
    MyAnimeListSyncWorker.perform_async(
      user_id: user_id,
      media_id: media_id,
      media_type: media_type,
      method: 'delete'
    ) if sync_to_mal?
  end
end
