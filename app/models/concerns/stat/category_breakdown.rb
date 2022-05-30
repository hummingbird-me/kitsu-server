class Stat < ApplicationRecord
  # Provides a base for both the anime and manga category breakdowns, so that most of the code can
  # be shared.  In future, as we move towards a larger set of media types, this will be helpful.
  module CategoryBreakdown
    extend ActiveSupport::Concern

    # The default stats_data values, automatically handled by the Stat superclass
    def default_data
      { 'total' => 0, 'categories' => {} }
    end

    # Recalculate this entire statistic from scratch
    # @return [self]
    def recalculate!
      library_entries = user.library_entries.completed_at_least_once.privacy(:public)
                            .by_kind(media_kind)
      categories = library_entries.joins(media_kind => :categories).group(:category_id).count

      self.stats_data = {}
      stats_data['categories'] = categories
      stats_data['total'] = library_entries.count

      self.recalculated_at = Time.now

      save!
    end

    # @param [LibraryEntry] a dirty library entry to update the categories based on
    # @return [void]
    def on_create(entry)
      on_update(entry)
    end

    # @param [LibraryEntry] a dirty library entry to update the categories based on
    # @return [void]
    def on_destroy(entry)
      return if entry.private?
      return unless entry.completed_at_least_once?

      stats_data['total'] -= 1
      update_categories_for(entry.media, by: -1)

      save!
    end

    # @param [LibraryEntry] a dirty library entry to update the categories based on
    # @return [void]
    def on_update(entry)
      return if entry.private?

      diff = LibraryEntryDiff.new(entry)
      change = if diff.became_completed? then +1
               elsif diff.became_uncompleted? then -1
               else
                 0
               end

      stats_data['total'] += change
      update_categories_for(entry.media, by: change)

      save!
    end

    # Override to load category titles at runtime so that they can be edited without a bulk rebuild
    # @return [#to_json] a JSON-serializable stats object
    def enriched_stats_data
      data = stats_data.deep_dup
      categories = Category.find(data['categories'].keys).index_by(&:id)
      data['categories'].transform_keys! { |id| categories[id.to_i] }
      data['categories'].select! { |category, _| category.parent_id == 228 }
      data['categories'].transform_keys!(&:title)
      data
    end

    # Increment or decrement the categories for a media by a given quantity
    # @param media [Media,#categories] the media whose categories to update
    # @param by [Integer] the number to update the categories by
    # @return [void]
    def update_categories_for(media, by: 0)
      media.categories.each do |category|
        category_id = category.id.to_s
        stats_data['categories'][category_id] ||= 0
        stats_data['categories'][category_id] += by
      end
    end

    included do
      before_validation do
        stats_data['categories'].transform_values! { |count| [count, 0].max }
      end
    end
  end
end
