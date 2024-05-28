# frozen_string_literal: true

class Episode < ApplicationRecord
  include WithNewFeed
  include Titleable
  include Mappable
  include DescriptionSanitation
  include UnitThumbnailUploader::Attachment(:thumbnail)

  belongs_to :media, polymorphic: true, inverse_of: :episodes
  has_many :videos, dependent: :destroy
  accepts_nested_attributes_for :videos, allow_destroy: true
  has_many :unit_timeline_stories,
    dependent: nil,
    class_name: 'TimelineStory::UnitTimelineStory',
    as: 'unit'

  validates :media, polymorphism: { type: Media }
  validates :number, presence: true
  validates :season_number, presence: true

  scope :for_progress, ->(progress) do
    reorder(:season_number, :number).limit(progress)
  end
  scope :for_range, ->(range) do
    where(number: range)
  end

  def self.length_mode
    mode, count = reorder(count_all: :desc).group(:length).count.first
    { mode:, count: }
  end

  def self.length_average
    reorder(nil).average(:length)
  end

  def self.length_total
    reorder(nil).sum(:length)
  end

  def self.create_defaults(count)
    episodes = ((1..count).to_a - pluck(:number)).map do |n|
      new(number: n, season_number: 1)
    end
    transaction { episodes.each(&:save) }
    where("number > #{count}").destroy_all
  end

  def feed
    EpisodeFeed.new(id)
  end

  def rails_admin_label
    "S#{season_number}E#{number} #{canonical_title}"
  end

  MediaTotalLengthCallbacks.hook(self)

  before_validation do
    self.length = media.episode_length if length.nil?
    self.season_number ||= 1

    # If we have non-default titles, strip the defaults
    self.titles = titles.reject { |_, t| /\AEpisode \d+\z/ =~ t || t.blank? }
    self.canonical_title = titles.keys.find { |t| t =~ /en/ } unless canonical_title
  end
  after_save { media.recalculate_episode_length! if saved_change_to_length? }
  after_destroy { media.recalculate_episode_length! }

  after_commit(on: :create) { feed.setup! }
end
