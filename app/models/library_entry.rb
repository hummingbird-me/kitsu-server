# == Schema Information
#
# Table name: library_entries
#
#  id              :integer          not null, primary key
#  finished_at     :datetime
#  media_type      :string           not null, indexed => [user_id], indexed => [user_id, media_id]
#  notes           :text
#  nsfw            :boolean          default(FALSE), not null
#  private         :boolean          default(FALSE), not null, indexed
#  progress        :integer          default(0), not null
#  progressed_at   :datetime
#  rating          :integer
#  reconsume_count :integer          default(0), not null
#  reconsuming     :boolean          default(FALSE), not null
#  started_at      :datetime
#  status          :integer          not null, indexed => [user_id]
#  time_spent      :integer          default(0), not null
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

class LibraryEntry < ApplicationRecord
  VALID_RATINGS = (2..20).to_a.freeze
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
  scope :privacy, ->(privacy) { where(private: !(privacy == :public)) }
  scope :visible_for, ->(user) {
    scope = user && !user.sfw_filter? ? all : sfw

    return scope.privacy(:public) unless user
    return scope if user.has_role?(:admin)

    scope.privacy(:public).or(
      where(user_id: user).privacy(:private)
    )
  }

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
    greater_than_or_equal_to: 2,
    less_than_or_equal_to: 20
  }, allow_blank: true
  validates :reconsume_count, numericality: {
    less_than_or_equal_to: 50,
    message: 'just... go outside'
  }
  validate :progress_limit
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

  before_destroy do
    review&.update_attribute(:library_entry_id, nil)
  end

  before_save do
    if status_changed? && completed?
      # update progress to the cap
      self.progress = media.progress_limit if media&.progress_limit
      # set finished_at and started_at for the first consume
      self.started_at ||= Time.now unless imported
      self.finished_at ||= Time.now unless imported
    end

    # When progress equals total episodes
    self.status = :completed if !status_changed? &&
                                progress == media&.progress_limit
    unless imported
      # When progress is changed, update progressed_at
      self.progressed_at = Time.now if progress_changed?
      # When marked current and started_at doesn't exist
      self.started_at ||= Time.now if current?
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

  after_commit(on: :create) do
    sync_entry(:create) # mal exporter
  end

  after_commit(on: :update) do
    sync_entry(:update) # mal exporter
  end

  after_create do
    # Stat STI
    case kind
    when :anime
      Stat::AnimeGenreBreakdown.increment(user, self)
      Stat::AnimeAmountConsumed.increment(user, self)
      Stat::AnimeFavoriteYear.increment(user, self)
    when :manga
      Stat::MangaGenreBreakdown.increment(user, self)
      Stat::MangaAmountConsumed.increment(user, self)
      Stat::MangaFavoriteYear.increment(user, self)
    end
  end

  after_destroy do
    sync_entry(:delete) # mal exporter
    # Stat STI
    case kind
    when :anime
      Stat::AnimeGenreBreakdown.decrement(user, self)
      Stat::AnimeAmountConsumed.decrement(user, self)
      Stat::AnimeFavoriteYear.decrement(user, self)
    when :manga
      Stat::MangaGenreBreakdown.decrement(user, self)
      Stat::MangaAmountConsumed.decrement(user, self)
      Stat::MangaFavoriteYear.decrement(user, self)
    end
  end

  def sync_to_mal?
    return unless media_type.in? %w[Anime Manga]

    myanimelist_linked_account.present?
  end

  def sync_entry(method)
    return unless sync_to_mal?

    # create log
    library_entry_log = LibraryEntryLog.create_for(
      method, self, myanimelist_linked_account
    )

    MyAnimeListSyncWorker.perform_async(
      # for create & update
      library_entry_id: id,
      # for delete
      user_id: user_id,
      media_id: media_id,
      media_type: media_type,
      # for all
      method: method,
      library_entry_log_id: library_entry_log.id
    )
  end

  def myanimelist_linked_account
    @mal_linked_account ||= User.find(user_id).linked_accounts.find_by(
      sync_to: true,
      type: 'LinkedAccount::MyAnimeList'
    )
  end
end
