# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: manga
#
#  id                        :integer          not null, primary key
#  abbreviated_titles        :string           is an Array
#  age_rating                :integer
#  age_rating_guide          :string
#  average_rating            :decimal(5, 2)
#  canonical_title           :string           default("en_jp"), not null
#  chapter_count             :integer
#  chapter_count_guess       :integer
#  cover_image_content_type  :string(255)
#  cover_image_file_name     :string(255)
#  cover_image_file_size     :integer
#  cover_image_meta          :text
#  cover_image_processing    :boolean
#  cover_image_top_offset    :integer          default(0)
#  cover_image_updated_at    :datetime
#  end_date                  :date
#  favorites_count           :integer          default(0), not null
#  popularity_rank           :integer
#  poster_image_content_type :string(255)
#  poster_image_file_name    :string(255)
#  poster_image_file_size    :integer
#  poster_image_meta         :text
#  poster_image_updated_at   :datetime
#  rating_frequencies        :hstore           default({}), not null
#  rating_rank               :integer
#  serialization             :string(255)
#  slug                      :string(255)
#  start_date                :date
#  subtype                   :integer          default(1), not null
#  synopsis                  :text
#  tba                       :string
#  titles                    :hstore           default({}), not null
#  user_count                :integer          default(0), not null
#  volume_count              :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# rubocop:enable Metrics/LineLength

class Manga < ApplicationRecord
  include Media
  include AgeRatings

  enum subtype: %i[manga novel manhua oneshot doujin manhwa oel]
  alias_attribute :progress_limit, :chapter_count
  alias_attribute :manga_type, :subtype

  rails_admin { fields :chapter_count, :volume_count }

  has_many :chapters
  has_many :manga_characters, dependent: :destroy
  has_many :manga_staff, dependent: :destroy
  has_many :media_attributes, through: :manga_media_attributes
  has_many :manga_media_attributes

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

  before_save do
    self.chapter_count_guess = nil if chapter_count

    if chapter_count == 1
      self.start_date = end_date if start_date.nil? && !end_date.nil?
      self.end_date = start_date if end_date.nil? && !start_date.nil?
    end
  end

  after_save do
    if chapter_count_guess_changed? && chapters.length != chapter_count_guess
      chapters.create_defaults(chapter_count_guess || 0)
    elsif chapter_count_changed? && chapters.length != chapter_count
      chapters.create_defaults(chapter_count || 0)
    end
  end
end
