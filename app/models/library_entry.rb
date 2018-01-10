# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: library_entries
#
#  id                :integer          not null, primary key
#  finished_at       :datetime
#  media_type        :string           not null, indexed => [user_id], indexed => [user_id, media_id]
#  notes             :text
#  nsfw              :boolean          default(FALSE), not null
#  private           :boolean          default(FALSE), not null, indexed
#  progress          :integer          default(0), not null
#  progressed_at     :datetime
#  rating            :integer
#  reaction_skipped  :integer          default(0), not null
#  reconsume_count   :integer          default(0), not null
#  reconsuming       :boolean          default(FALSE), not null
#  started_at        :datetime
#  status            :integer          not null, indexed => [user_id]
#  time_spent        :integer          default(0), not null
#  volumes_owned     :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  anime_id          :integer          indexed
#  drama_id          :integer          indexed
#  manga_id          :integer          indexed
#  media_id          :integer          not null, indexed => [user_id, media_type]
#  media_reaction_id :integer
#  user_id           :integer          not null, indexed, indexed => [media_type], indexed => [media_type, media_id], indexed => [status]
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
# Foreign Keys
#
#  fk_rails_a7e4cb3aba  (media_reaction_id => media_reactions.id)
#
# rubocop:enable Metrics/LineLength

class LibraryEntry < ApplicationRecord
  VALID_RATINGS = (2..20).to_a.freeze
  MEDIA_ASSOCIATIONS = %i[anime manga drama].freeze

  belongs_to :user, touch: true
  belongs_to :media, polymorphic: true
  belongs_to :anime
  belongs_to :manga
  belongs_to :drama
  has_one :review, dependent: :destroy
  has_one :media_reaction, dependent: :destroy
  has_many :library_events, dependent: :destroy

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
  enum reaction_skipped: {
    unskipped: 0,
    skipped: 1,
    ignored: 2
  }
  attr_accessor :imported

  validates :user, :status, :progress, :reconsume_count, presence: true
  validates :media, polymorphism: { type: Media }, presence: true
  validates :anime_id, uniqueness: { scope: :user_id }, allow_nil: true
  validates :manga_id, uniqueness: { scope: :user_id }, allow_nil: true
  validates :drama_id, uniqueness: { scope: :user_id }, allow_nil: true
  validates :progress, numericality: { greater_than_or_equal_to: 0 }
  validates :reconsume_count, numericality: { greater_than_or_equal_to: 0 }
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

  counter_culture :user, column_name: ->(le) { 'ratings_count' if le.rating },
                         execute_after_commit: true
  scope :rated, -> { where.not(rating: nil) }
  scope :following, ->(user) do
    user_id = user.respond_to?(:id) ? user.id : user
    user_id = sanitize(user_id.to_i) # Juuuuuust to be safe
    follows = Follow.arel_table
    sql = follows.where(follows[:follower_id].eq(user_id)).project(:followed_id)
    where("user_id IN (#{sql.to_sql})")
  end

  def progress_limit
    return unless progress
    progress_cap = media&.progress_limit
    default_cap = [media&.default_progress_limit, 50].compact.max

    if progress_cap&.nonzero?
      errors.add(:progress, 'cannot exceed length of media') if progress > progress_cap
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
    if anime.present? then :anime
    elsif manga.present? then :manga
    elsif drama.present? then :drama
    end
  end

  LibraryTimeSpentCallbacks.hook(self)
  LibraryStatCallbacks.hook(self)
  LibraryEventCallbacks.hook(self)

  before_validation do
    # TEMPORARY: If media is set, copy it to kind_id, otherwise if kind_id is
    # set, copy it to media!
    if kind && send(kind).present?
      self.media = send(kind)
    else
      kind = media_type&.underscore
      send("#{kind}=", media) if kind
    end

    self.nsfw = media.nsfw? if media_id_changed?
    true
  end

  before_destroy do
    review&.update_attribute(:library_entry_id, nil)
  end

  before_save do
    # When progress equals total episodes
    self.status = :completed if !status_changed? && progress == media&.progress_limit

    if status_changed? && completed?
      # update progress to the cap
      self.progress = media.progress_limit if media&.progress_limit
    end

    unless imported
      self.progressed_at = Time.now if status_changed? || progress_changed?

      if status_changed?
        self.started_at ||= Time.now if current?
        self.started_at ||= Time.now if completed?
        self.finished_at ||= Time.now if completed?
      end

      self.status = :current if progress_changed? && !status_changed?
    end
  end

  after_save do
    # Disable activities and trending vote on import
    unless imported || private?
      activity.rating(rating)&.create if rating_changed? && rating.present?
      activity.status(status)&.create if status_changed?
      # If the progress has changed, make an activity unless status is changing to completed
      activity.progress(progress)&.create if progress_changed? && !(status_changed? && completed?)
      media.trending_vote(user, 0.5) if progress_changed?
      media.trending_vote(user, 1.0) if status_changed?
    end

    if rating_changed?
      media.transaction do
        media.decrement_rating_frequency(rating_was)
        media.increment_rating_frequency(rating)
      end
      user.update_feed_completed!
      user.update_profile_completed!
    end

    if progress_changed?
      guess = [(progress + 1), media.default_progress_limit].min
      media.update_unit_count_guess(guess)
    end
  end

  after_commit on: :update, if: :progress_changed? do
    MediaFollowUpdateWorker.perform_for_entry(self, :update, progress_was, progress)
  end

  after_commit on: :destroy do
    MediaFollowUpdateWorker.perform_for_entry(self, :destroy, progress_was)
  end

  after_commit on: :create do
    MediaFollowUpdateWorker.perform_for_entry(self, :create, progress)
  end

  after_commit(on: :create, if: :sync_to_mal?) do
    LibraryEntryLog.create_for(:create, self, myanimelist_linked_account)
    ListSync::UpdateWorker.perform_async(myanimelist_linked_account.id, id)
  end

  after_commit(on: :update, if: :sync_to_mal?) do
    LibraryEntryLog.create_for(:update, self, myanimelist_linked_account)
    ListSync::UpdateWorker.perform_async(myanimelist_linked_account.id, id)
  end

  after_commit(on: :destroy, if: :sync_to_mal?) do
    LibraryEntryLog.create_for(:destroy, self, myanimelist_linked_account)
    ListSync::DestroyWorker.perform_async(myanimelist_linked_account.id,
      media_type, media_id)
  end

  def sync_to_mal?
    return unless media_type.in? %w[Anime Manga]
    return false if imported

    myanimelist_linked_account.present?
  end

  def myanimelist_linked_account
    @mal_linked_account ||= User.find(user_id).linked_accounts.find_by(
      sync_to: true,
      type: 'LinkedAccount::MyAnimeList'
    )
  end
end
