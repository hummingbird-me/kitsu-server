class Feed
  class ActivityList
    class Page
      # Verbs which get their groups stripped to one activity
      STRIPPED_VERBS = Set.new(%w[post comment follow review media_reaction]).freeze

      attr_reader :opts, :data

      # @param data a raw chunk of payload data from Stream's API
      # @param opts the options to apply to this page
      def initialize(data, opts = {})
        @data = data
        @opts = opts
      end

      # Collapse the waveform, apply the processing to the data
      def to_a
        res = data
        res = apply_selects(res, opts[:fast_selects] || [])
        res = strip_unused(res)
        unless opts[:includes].blank?
          res = enrich(res, opts[:includes])
          res = strip_unenriched(res, opts[:includes])
        end
        res = apply_selects(res, opts[:slow_selects] || [])
        res = apply_maps(res, opts[:maps] || [])
        res = wrap(res)
        res
      end

      private

      # Apply a list of selects to the list of activities
      def apply_selects(activities, selects)
        return activities if selects.empty?
        # We use map+reject(blank) so that we can modify the activities in the
        # groups
        activities = activities.lazy.map do |act|
          if act['activities'] # recurse into activity groups
            catch(:remove_group) do
              act['activities'] = apply_selects(act['activities'], selects)
              act
            end
          else # Activity
            next unless selects.all? { |proc| proc.call(act) }
            act
          end
        end
        activities = activities.reject do |act|
          act.blank? || (act['activities'] && act['activities'].blank?)
        end
        activities.to_a
      end

      # Apply a list of maps to the list of activities
      def apply_maps(activities, maps)
        return activities if maps.empty?
        activities.map do |act|
          if act['activities'] # Recurse into activity groups
            act['activities'] = apply_maps(act['activities'], maps)
            act
          else
            maps.reduce(act) { |acc, elem| elem.call(acc) }
          end
        end
      end

      # Run it through the StreamRails::Enrich process
      def enrich(activities, includes)
        enricher = StreamRails::Enrich.new(includes)
        if opts[:aggregated]
          enricher.enrich_aggregated_activities(activities)
        else
          enricher.enrich_activities(activities)
        end
      end

      def empty?
        data.zero?
      end

      # For performance, we drop older activities on groups where we only need
      # one. These groups are identified by verb (comment, post, review, follow)
      def strip_unused(activity_groups)
        activity_groups.each do |group|
          return activity_groups unless group['activities']
          next unless STRIPPED_VERBS.include?(group['verb'])
          group['activities'] = [group['activities'].first]
        end
        activity_groups
      end

      # Strips enrichment failures from the activities
      # TODO: switch to using apply_maps
      def strip_unenriched(activities, includes)
        activities.map do |act|
          if act['activities'] # Recurse into activity groups
            act['activities'] = strip_unenriched(act['activities'], includes)
          else
            includes.each do |key|
              # If it's an array (nested enrichment), grab the top level
              key = key.first if key.is_a?(Array)
              # Delete if it's still a string
              act.delete(key.to_s) if act[key.to_s].is_a?(String)
            end
          end
          act
        end
      end

      # Wrap activities in Feed::Activity and Feed::ActivityGroup instances
      def wrap(activities)
        activities.map do |act|
          if act['activities']
            # Feed::ActivityGroup automatically converts activites in it
            Feed::ActivityGroup.new(opts[:feed], act)
          else
            Feed::Activity.new(opts[:feed], act)
          end
        end
      end
    end
  end
end
