module Zorro
  class Wrapper
    FILE_PREFIX = 'https://aozora-assets.s3.amazonaws.com/'.freeze

    def initialize(data)
      @data = data
    end

    def id
      @data['_id']
    end

    def created_at
      @data['createdAt']
    end

    def updated_at
      @data['updatedAt']
    end

    def self.file(name)
      "#{FILE_PREFIX}#{name}"
    end
    delegate :file, to: :class
    delegate :assoc, to: Zorro::DB
  end
end
