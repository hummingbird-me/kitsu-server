class Feed
  class Global < Feed
    include MediaUpdatesFilterable

    def initialize
      super('global')
    end
  end
end
