class Chapter < ApplicationRecord
  include Titleable
  include DescriptionSanitation
  include UnitThumbnailUploader::Attachment(:thumbnail)

  belongs_to :manga
  belongs_to :volume, counter_cache: true, optional: true

  validates :number, presence: true
  validates :volume_number, presence: true

  scope :for_progress, ->(progress) do
    order(:volume_number, :number).limit(progress)
  end

  def self.create_defaults(count)
    chapters = ((1..count).to_a - pluck(:number)).map do |n|
      new(number: n, volume_number: 1)
    end
    transaction { chapters.each(&:save) }
    where("number > #{count}").destroy_all
  end

  def feed
    ChapterFeed.new(id)
  end

  after_commit(on: :create) { feed.setup! }
end
