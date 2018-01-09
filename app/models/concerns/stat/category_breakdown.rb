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
      library_entries = user.library_entries.completed.by_kind(media_kind)
      categories = library_entries.joins(media_kind => :categories)
                                  .group(:category_id).count

      self.stats_data = {}
      stats_data['categories'] = categories
      stats_data['total'] = library_entries.count

      save!
    end

    # @param [LibraryEntry] a media to increment the categories of
    # @return [void]
    def on_create(entry)
      stats_data['total'] += 1

      entry.media.categories.each do |category|
        stats_data['categories'][category.id] ||= 0
        stats_data['categories'][category.id] += 1
      end

      save!
    end

    # @param [LibraryEntry] a media to decrement the categories of
    # @return [void]
    def on_destroy(entry)
      stats_data['total'] -= 1

      entry.media.categories.each do |category|
        stats_data['categories'][category.id] ||= 0
        stats_data['categories'][category.id] -= 1
      end

      save!
    end

    # Override to load category titles at runtime so that they can be edited without a bulk rebuild
    # @return [#to_json] a JSON-serializable stats object
    def enriched_stats_data
      stats_data = default_data.merge(stats_data || {})
      categories = Category.find(stats_data['categories'].keys).index_by(&:id)
      stats_data['categories'].transform_keys! { |id| categories[id].title }
      stats_data
    end

    included do
      before_validation do
        stats_data['categories'].transform_values! { |count| [count, 0].max }
      end
    end
  end
end
