module Streamable
  extend ActiveSupport::Concern

  included do
    belongs_to :streamer, optional: false

    validates :streamer, presence: true
    validates :dubs, presence: true
    validates :regions, length: { minimum: 1 }

    scope :dubbed, ->(langs) { where('dubs @> ARRAY[?]::varchar[]', langs) }
    scope :subbed, ->(langs) { where('subs @> ARRAY[?]::varchar[]', langs) }

    # @!method self.available_in(region)
    #   Filter to videos available in a given region
    #
    #   @param region [String] the ISO 3166-1 alpha-2 code for a region
    #   @return [ActiveRecord::Relation] a relation of videos available in the specified region
    scope :available_in, ->(region) { where('regions <@ ARRAY[?]::varchar[]', region) }

    # Determine if this streamable type is available within a given region
    #
    # @param region [String] the ISO 3166-1 alpha-2 code for a region
    # @return [Boolean] whether the video is available in the specified region
    def available_in?(region)
      regions.include?(region)
    end
  end
end
