class Feed
  module DSL
    extend ActiveSupport::Concern

    included do
      class_attribute :_feed_name
    end

    class_methods do
      # Define the feed name
      def feed_name(name)
        self._feed_name = name
      end

      def inherited(subclass)
        super(subclass)
        # If there's no _feed_name already set...
        return if subclass._feed_name || subclass.name.blank?
        # Configure the default _feed_name
        subclass._feed_name = subclass.name.gsub(/\AFeed::|Feed\z/, '').underscore
      end
    end
  end
end
