class GlobalStat < ApplicationRecord
  module AmountConsumed
    extend ActiveSupport::Concern

    class_methods do
      def recalculate!
        first_or_initialize.recalculate!
      end
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
      percentiles = (0..1).step(BigDecimal('0.01')).to_a.map(&:to_s)
      stat_class.pluck(<<-SQL).first
        percentile_disc(array[#{percentiles.join(',')}])
        WITHIN GROUP (ORDER BY (stats_data->>'#{field}')::integer)
      SQL
    end

    def average_for(field)
      stat_class.average("(stats_data->>'#{field}')::integer").to_f
    end
  end
end
