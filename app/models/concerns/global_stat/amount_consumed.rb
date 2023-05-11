# frozen_string_literal: true

class GlobalStat < ApplicationRecord
  module AmountConsumed
    extend ActiveSupport::Concern

    class_methods do
      delegate :recalculate!, to: :first_or_initialize
    end

    def recalculate!
      update(stats_data: {
        'percentiles' => {
          'media' => percentiles_for('media'),
          'units' => percentiles_for('units'),
          'time' => percentiles_for('time')
        },
        'average' => {
          'media' => average_for('media'),
          'units' => average_for('units'),
          'time' => average_for('time')
        }
      })
    end

    def percentiles_for(field)
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute('SET LOCAL statement_timeout = 0')

        query = Arel.sql("percentile_disc(array[#{percentiles.join(',')}])
        WITHIN GROUP (ORDER BY (stats_data->>'#{field}')::integer)")
        stats_for(field).pick(query)
      end
    end

    def percentiles
      @percentiles ||= (0..1).step(BigDecimal('0.01')).to_a.map(&:to_s)
    end

    def average_for(field)
      stats_for(field).average("(stats_data->>'#{field}')::integer").to_f
    end

    def stats_for(field)
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute('SET LOCAL statement_timeout = 0')

        stat_class.where(stats_query(field))
      end
    end

    def stats_query(field)
      return media_query if field == 'media'

      "#{media_query} AND (stats_data->>'#{field}')::integer > 0"
    end

    def media_query
      "(stats_data->>'media')::integer > 5"
    end
  end
end
