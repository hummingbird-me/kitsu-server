module Zorro
  class Wrapper
    FILE_PREFIX = 'https://aozora-assets.s3.amazonaws.com/'.freeze

    # @param [String] data The Data to wrap up
    def initialize(data)
      @data = data
    end

    # @return [String] the MongoDB ID from Aozora
    def id
      @data['_id']
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
      return nil unless name.present?
      "#{FILE_PREFIX}#{name}".tap { |x| puts x }
    end

    # Shortcuts to {Wrapper.file} and {Zorro::DB.assoc} for subclasses to use
    delegate :file, to: :class
    delegate :assoc, to: Zorro::DB
  end
end
