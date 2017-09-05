# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: chapters
#
#  id                     :integer          not null, primary key
#  canonical_title        :string           default("en_jp"), not null
#  length                 :integer
#  number                 :integer          not null
#  published              :date
#  synopsis               :text
#  thumbnail_content_type :string(255)
#  thumbnail_file_name    :string(255)
#  thumbnail_file_size    :integer
#  thumbnail_meta         :text
#  thumbnail_updated_at   :datetime
#  titles                 :hstore           default({}), not null
#  volume_number          :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  manga_id               :integer          indexed
#
# Indexes
#
#  index_chapters_on_manga_id   (manga_id)
#
# rubocop:enable Metrics/LineLength

class Chapter < ApplicationRecord
  include Titleable

  belongs_to :manga

  has_attached_file :thumbnail

  validates :manga, presence: true
  validates :number, presence: true
  validates :volume_number, presence: true
  validates_attachment :thumbnail, content_type: {
    content_type: %w[image/jpg image/jpeg image/png]
  }

  scope :for_progress, ->(progress) do
    order(:volume_number, :number).limit(progress)
  end

  def self.create_defaults(count)
    chapters = ((1..count).to_a - pluck(:number)).map do |n|
      new(number: n, volume_number: 1, titles: { en_jp: "Chapter #{n}" })
    end
    transaction { chapters.each(&:save) }
    where("number > #{count}").destroy_all
  end

  def feed
    ChapterFeed.new(id)
  end

  before_save do
    self.synopsis = Sanitize.fragment(synopsis, Sanitize::Config::RESTRICTED)
  end

  after_commit(on: :create) { feed.setup! }
end
