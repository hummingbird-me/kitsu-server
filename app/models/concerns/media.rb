module Media
  extend ActiveSupport::Concern

  STATUSES = %w[tba unreleased upcoming current finished].freeze

  included do
    include Titleable
    include Rateable
    include Rankable
    include Trendable
    include WithCoverImage
    include Sluggable

    friendly_id :slug_candidates, use: %i[slugged finders history]
    resourcify
    has_attached_file :poster_image, styles: {
      tiny: ['110x156#', :jpg],
      small: ['284x402#', :jpg],
      medium: ['390x554#', :jpg],
      large: ['550x780#', :jpg]
    }, convert_options: {
      tiny: '-quality 90 -strip',
      small: '-quality 75 -strip',
      medium: '-quality 70 -strip',
      large: '-quality 60 -strip'
    }

    update_index("media##{name.underscore}") { self }
    update_algolia('AlgoliaMediaIndex')

    has_and_belongs_to_many :genres
    has_and_belongs_to_many :categories,
      before_add: :inc_total_media_count,
      before_remove: :dec_total_media_count
    has_many :castings, as: 'media'
    has_many :installments, as: 'media'
    has_many :franchises, through: :installments
    has_many :library_entries, as: 'media', dependent: :destroy,
                               inverse_of: :media
    has_many :media_reactions, dependent: :destroy
    has_many :mappings, as: 'item', dependent: :destroy
    has_many :reviews, as: 'media', dependent: :destroy
    has_many :media_relationships,
      class_name: 'MediaRelationship',
      as: 'source',
      dependent: :destroy
    has_many :inverse_media_relationships,
      class_name: 'MediaRelationship',
      as: 'destination',
      dependent: :destroy
    has_many :favorites, as: 'item', dependent: :destroy,
                         inverse_of: :item
    has_many :media_attributes,
      class_name: 'MediaAttribute',
      dependent: :destroy
    has_many :media_attribute_votes,
      class_name: 'MediaAttributeVote',
      dependent: :destroy
    delegate :year, to: :start_date, allow_nil: true

    # finished: end date has passed
    # current: currently between start and end date
    # upcoming: starts within the next 3 months
    # unreleased: starts in future, outside of upcoming range
    # tba: dates are to be announced
    scope :past, -> { where('start_date <= ?', Date.today) }
    scope :finished, -> { past.where('end_date < ?', Date.today) }
    scope :current, -> do
      past.where('end_date >= ? OR end_date IS ?', Date.today, nil)
    end
    scope :future, -> { where('start_date > ?', Date.today) }
    scope :upcoming, -> do
      future.where('start_date <= ?', Date.today + 3.months)
    end
    scope :unreleased, -> do
      future.where('start_date > ?', Date.today + 3.months)
    end
    scope :tba, -> { where('start_date IS ? AND end_date IS ?', nil, nil) }

    validates_attachment :poster_image, content_type: {
      content_type: %w[image/jpg image/jpeg image/png]
    }

    after_commit :setup_feed, on: :create
  end

  def slug_candidates
    [
      -> { canonical_title },
      -> { titles[:en_jp] }
    ]
  end

  def mapping_for(site)
    mappings.where(external_site: site).first
  end

  # How long the series ran for, or nil if the start date is unknown
  def run_length
    (end_date || Date.today) - start_date if start_date
  end

  def status
    return :tba if start_date.nil? && end_date.nil?
    return :finished if end_date&.past?
    return :current if start_date&.past? || start_date&.today?
    return :upcoming if start_date && start_date <= Date.today + 3.months
    return :unreleased if start_date&.future?
  end

  def feed
    @feed ||= MediaFeed.new(self.class.name, id)
  end

  def setup_feed
    feed.setup!
  end

  def poster_image_changed?
    poster_image.dirty?
  end

  private

  def inc_total_media_count(model)
    Category.increment_counter('total_media_count', model.id)
  end

  def dec_total_media_count(model)
    Category.decrement_counter('total_media_count', model.id)
  end
end
