class Manga < ApplicationRecord
  include Media
  include AgeRatings

  enum subtype: { manga: 0, novel: 1, manhua: 2, oneshot: 3, doujin: 4, manhwa: 5,
                  oel: 6 }
  alias_attribute :progress_limit, :chapter_count
  alias_attribute :manga_type, :subtype

  rails_admin { fields :chapter_count, :volume_count }

  has_many :chapters
  has_many :manga_characters, dependent: :destroy
  has_many :manga_staff, dependent: :destroy
  has_many :manga_media_attributes
  has_many :media_attributes, through: :manga_media_attributes

  validates :chapter_count, numericality: { greater_than: 0 }, allow_nil: true

  def unit(number)
    chapters.where(number: number).first
  end

  def default_progress_limit
    # TODO: Actually provide good logic for this
    5000
  end

  def slug_candidates
    [
      -> { canonical_title }, # attack-on-titan
      -> { [canonical_title, year] }, # attack-on-titan-2004
      -> { [canonical_title, year, subtype] } # attack-on-titan-2004-doujin
    ]
  end

  def update_unit_count_guess(guess)
    return if chapter_count || (chapter_count_guess && chapter_count_guess > guess)
    update(chapter_count_guess: guess)
  end

  def self.unit_class
    Chapter
  end

  before_save do
    self.chapter_count_guess = nil if chapter_count

    if chapter_count == 1
      self.start_date = end_date if start_date.nil? && !end_date.nil?
      self.end_date = start_date if end_date.nil? && !start_date.nil?
    end
  end

  after_save do
    if (saved_change_to_chapter_count_guess? && !chapter_count_guess.nil?) &&
       chapters.length != chapter_count_guess
      chapters.create_defaults(chapter_count_guess || 0)
    elsif saved_change_to_chapter_count? && chapters.length != chapter_count
      chapters.create_defaults(chapter_count || 0)
    end
  end
end
