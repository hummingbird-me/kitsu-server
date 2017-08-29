module Zorro
  class Wrapper
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

    delegate :assoc, to: Zorro::DB
  end
end
