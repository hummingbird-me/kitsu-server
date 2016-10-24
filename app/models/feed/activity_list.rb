class Feed
  class ActivityList
    attr_accessor :data, :feed, :page_number, :page_size, :including
    %i[limit offset ranking].each do |key|
      define_method(key) do |value|
        self.dup.tap { |al| al.data[key] = value }
      end
    end
    alias_method :per, :limit

    def initialize(feed, data = {})
      @feed = feed
      @data = data.with_indifferent_access
    end

    def page(page_number = nil, id_lt: nil)
      if page_number
        dup.tap do |al|
          al.page_number = page_number
          al.update_pagination! if page_size
        end
      elsif id_lt
        self.where_id(:lt, id_lt)
      else
        raise ArgumentError, 'Must provide an offset or id_lt'
      end
    end

    def per(page_size)
      dup.tap do |al|
        al.page_size = page_size
        al.update_pagination! if page_number
      end
    end

    def includes(*relationships)
      self.dup.tap do |al|
        al.including = [relationships].flatten.map(&:to_sym)
        al.including += including if including.present?
      end
    end

    def update_pagination!
      data[:limit] = page_size
      data[:offset] = (page_number - 1) * page_size
    end

    def where_id(operator, id)
      self.dup.tap { |al| al.data["id_#{operator}"] = id }
    end

    def new(data = {})
      Feed::Activity.new(feed, data)
    end

    def add(activity)
      feed.stream_feed.add_activity(activity.as_json)
    end
    alias_method :<<, :add

    def update(activity)
      Feed.client.update_activity(activity.as_json)
    end

    def destroy(activity)
      feed.stream_feed.remove_activity(activity.foreign_id, foreign_id: true)
    end

    def results
      feed.stream_feed.get(data)['results']
    end

    def enriched_results
      if feed.aggregated? || feed.notification?
        enricher.enrich_aggregated_activities(results)
      else
        enricher.enrich_activities(results)
      end
    end

    def enricher
      StreamRails::Enrich.new(including)
    end

    def to_a
      if feed.aggregated? || feed.notification?
        enriched_results.map do |res|
          strip_unfound(Feed::ActivityGroup.new(feed, res))
        end
      else
        enriched_results.map do |res|
          strip_unfound(Feed::Activity.new(feed, res))
        end
      end
    end

    private

    # Strips unfound
    def strip_unfound(activity)
      # Recurse into activities if we're passed an ActivityGroup
      if activity.respond_to?(:activities)
        activity.dup.tap do |ag|
          ag.activities = activity.activities.map { |a| strip_unfound(a) }
        end
      else
        activity.dup.tap do |act|
          # For each field we've asked to have included
          including.each do |key|
            # Delete it if it's still a String
            act.delete_field(key) if act[key].is_a? String
          end
        end
      end
    end
  end
end
