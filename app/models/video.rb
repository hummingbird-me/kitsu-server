class Video < ApplicationRecord
  belongs_to :episode, required: true
  belongs_to :streamer, required: true

  validates :url, presence: true
  validates :available_regions, length: { minimum: 1 }

  # @!method self.available_in(region)
  #   Filter to videos available in a given region
  #
  #   @param region [String] the ISO 3166-1 alpha-2 code for a region
  #   @return [ActiveRecord::Relation] a relation of videos available in the specified region
  scope :available_in, ->(region) { where('available_regions <@ ARRAY[?]::varchar[]', region) }

  # Determine if this video is available within a given region
  #
  # @param region [String] the ISO 3166-1 alpha-2 code for a region
  # @return [Boolean] whether the video is available in the specified region
  def available_in?(region)
    available_regions.include?(region)
  end
end
