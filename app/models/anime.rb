class Anime < ApplicationRecord
  SEASONS = %w[winter spring summer fall].freeze

  include Media
  include AgeRatings
  include Episodic

  enum subtype: { TV: 0, special: 1, OVA: 2, ONA: 3, movie: 4, music: 5 }
  has_many :streaming_links, as: 'media', dependent: :destroy
  has_many :producers, through: :anime_productions
  has_many :anime_productions, dependent: :destroy
  has_many :anime_characters, dependent: :destroy
  has_many :anime_staff, dependent: :destroy
  has_many :anime_media_attributes
  has_many :media_attributes, through: :anime_media_attributes
  alias_attribute :show_type, :subtype

  rails_admin { fields :episode_count }

  update_index('media#anime') { self }

  def slug_candidates
    # Prefer the canonical title or romaji title before anything else
    candidates = [
      -> { canonical_title } # attack-on-titan
    ]
    if subtype == :TV
      # If it's a TV show with a name collision, common practice is to
      # specify the year (ex: kanon-2006)
      candidates << -> { [canonical_title, year] }
    else
      # If it's not TV and it's having a name collision, it's probably the
      # movie or OVA for a series (ex: attack-on-titan-movie)
      candidates << -> { [canonical_title, subtype] }
      candidates << -> { [canonical_title, subtype, year] }
    end
    candidates
  end

  def season
    case start_date.try(:month)
    when 12, 1, 2 then :winter
    when 3, 4, 5 then :spring
    when 6, 7, 8 then :summer
    when 9, 10, 11 then :fall
    end
  end

  def season_changed?
    start_date_changed?
  end

  # Season year is the year, adjusted so that December is part of the next year
  def season_year
    if start_date.try(:month) == 12
      year + 1
    else
      year
    end
  end
  alias_method :season_year_changed?, :season_changed?
  alias_method :year_changed?, :season_changed?

  def update_unit_count_guess(guess)
    return if episode_count || (episode_count_guess && episode_count_guess > guess)
    update(episode_count_guess: guess)
  end

  def self.unit_class
    Episode
  end

  def self.fuzzy_find(title)
    MediaIndex::Anime.query(multi_match: {
      fields: %w[titles.* abbreviated_titles description actors characters],
      query: title,
      fuzziness: 2,
      max_expansions: 15,
      prefix_length: 2
    }).preload.first
  end

  before_save do
    self.episode_count_guess = nil if episode_count

    if episode_count == 1
      self.start_date = end_date if start_date.nil? && !end_date.nil?
      self.end_date = start_date if end_date.nil? && !start_date.nil?
    end
  end

  after_save do
    if (saved_change_to_episode_count_guess? && !episode_count_guess.nil?) &&
       episodes.length != episode_count_guess
      episodes.create_defaults(episode_count_guess || 0)
    elsif saved_change_to_episode_count? && episodes.length != episode_count
      episodes.create_defaults(episode_count || 0)
    end
  end
end
