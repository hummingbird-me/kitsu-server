class Feed
  module DSL
    extend ActiveSupport::Concern

    included do
      class_attribute :_filters, :_feed_type, :_feed_name
      protected :_filters, :_feed_type

      # Set up the _filters hash so that we have our hash structure already
      # prepared and can just dup it off for subclasses
      self._filters = Hash.new { {} }
      self._feed_type = :aggregated
    end

    class_methods do # rubocop:disable Metrics/BlockLength
      # Add a filter option to the feed class
      def filter(name, options = {})
        options[:hash] = [name, options[:verb].hash || options[:proc]].hash
        options[:proc] = ->(activity) do
          options[:verb].include?(activity[:verb])
        end
        _filters[name] = _filters[name].merge(options)
      end

      # Define the base feed type
      def feed_type(type)
        self._feed_type = type
      end

      # Define the feed name
      def feed_name(name)
        self._feed_name = name
        Feed.register!(name, self)
      end

      # Generates unique identifiers for each filter, based on the parameters
      # which filter it
      def _filter_keys
        _filters.map { |key, opts| [opts[:hash], key] }.to_h
      end

      # Gets the filters which intersect between this and another Feed class
      def filters_shared_with(target)
        shared_filter_hashes = (_filter_keys.keys & target._filter_keys.keys)
        _filter_keys.values_at(*shared_filter_hashes)
      end

      def inherited(subclass)
        super(subclass)
        # If there's no _feed_name already set...
        unless subclass._feed_name
          return unless subclass.name
          # Configure the default _feed_name
          subclass._feed_name = subclass.name.gsub(/\AFeed::|Feed\z/, '')
                                        .underscore
          # Register our feed name
          Feed.register!(subclass._feed_name, subclass)
        end
        # Duplicate the _filters hash
        subclass._filters = _filters.deep_dup
      end
    end
  end
end
