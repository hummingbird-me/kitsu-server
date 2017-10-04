module Zorro
  class Wrapper
    FILE_PREFIX = 'https://aozora-assets.s3.amazonaws.com/'.freeze

    # @param [String] data The Data to wrap up
    def initialize(data, collection: nil)
      @data = data
      @collection = collection
    end

    # The Parse ID is 10 characters of base62, which means there's a 50% chance of collision after
    # just 3 million rows.  Because some Kitsu models map to multiple Aozora collections, we cannot
    # guarantee uniqueness without a collection prefix.
    #
    # @return [String] the MongoDB ID from Aozora
    def id
      [@collection, @data['_id']].compact.join('$')
    end

    # @return [Time] the creation time
    def created_at
      @data['_created_at']
    end

    # @return [Time] the update time
    def updated_at
      @data['_updated_at']
    end

    # Wrap a filename into a complete fully-qualified URL to the file in the Aozora S3 bucket
    # @param name [String] the name of the file
    # @return [String] the complete URL to the file
    def self.file(name)
      "#{FILE_PREFIX}#{name}" if name.present?
    end

    # Shortcuts to {Wrapper.file} and {Zorro::DB.assoc} for subclasses to use
    delegate :file, to: :class
    delegate :assoc, to: Zorro::DB
  end
end
