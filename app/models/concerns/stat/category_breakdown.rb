class Stat < ApplicationRecord
  module CategoryBreakdown
    extend ActiveSupport::Concern

    DEFAULT_STATS = {
      'total' => 0,
      'total_media' => 0,
      'all_categories' => {}
    }.freeze

    # Fully regenrate data
    def recalculate!
      categories = library_entries.eager_load(media_column => :categories)
                                  .where.not(categories: { slug: nil })
                                  .group(:'categories.slug').count

      # clear stats_data
      self.stats_data = {}
      stats_data['all_categories'] = categories
      stats_data['total'] = categories.values.reduce(:+)
      stats_data['total_media'] = library_entries.count

      save!
    end

    def library_entries
      @le ||= user.library_entries.by_kind(media_column).where('progress > 0')
    end

    class_methods do
      def increment(user, library_entry)
        record = user.stats.find_or_initialize_by(
          type: "Stat::#{media_type}CategoryBreakdown"
        )
        # set default stats if it doesn't exist
        record.stats_data = DEFAULT_STATS.deep_dup if record.new_record?

        library_entry.media.categories.each do |category|
          # In case recalculate has not been run this will prevent any errors
          record.stats_data['all_categories'][category.slug] ||= 0
          record.stats_data['total'] ||= 0
          record.stats_data['total_media'] ||= 0

          record.stats_data['all_categories'][category.slug] += 1
          record.stats_data['total'] += 1
        end

        # remove total_media outside of loop
        record.stats_data['total_media'] += 1

        record.save!
      end

      def decrement(user, library_entry)
        record = user.stats.find_by(
          type: "Stat::#{media_type}CategoryBreakdown"
        )

        return unless record

        library_entry.media.categories.each do |category|
          next unless record.stats_data['all_categories'][category.slug]

          record.stats_data['all_categories'][category.slug] -= 1
          record.stats_data['total'] -= 1
        end

        # remove total_media outside of loop
        record.stats_data['total_media'] -= 1

        record.save!
      end
    end
  end
end
