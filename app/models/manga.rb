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
#  cover_image_content_type  :string(255)
#  cover_image_file_name     :string(255)
#  cover_image_file_size     :integer
#  cover_image_processing    :boolean
#  cover_image_top_offset    :integer          default(0)
#  cover_image_updated_at    :datetime
#  end_date                  :date
#  favorites_count           :integer          default(0), not null
#  popularity_rank           :integer
#  poster_image_content_type :string(255)
#  poster_image_file_name    :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  rating_frequencies        :hstore           default({}), not null
#  rating_rank               :integer
#  serialization             :string(255)
#  slug                      :string(255)
#  start_date                :date
#  status                    :integer
#  subtype                   :integer          default(1), not null
#  synopsis                  :text
#  titles                    :hstore           default({}), not null
#  user_count                :integer          default(0), not null
#  volume_count              :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# rubocop:enable Metrics/LineLength

class Manga < ApplicationRecord
  STATUSES = %i[not_published upcoming publishing finished]

  include Media
  include AgeRatings

  enum subtype: %i[manga novel manhua oneshot doujin manhwa oel]
  alias_attribute :progress_limit, :chapter_count
  alias_attribute :manga_type, :subtype

  rails_admin { fields :chapter_count, :volume_count }

  has_many :chapters
  has_many :manga_characters, dependent: :destroy
  has_many :manga_staff, dependent: :destroy

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

  def status
    return :not_published if start_date > Date.today
    return :upcoming if start_date.month - Date.today.month < 4
    return :publishing if start_date <= Date.today && end_date >= Date.today
    return :finished if end_date <= Date.today
  end
end
