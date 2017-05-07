# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  stats_data :jsonb            not null
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null, indexed
#
# Indexes
#
#  index_stats_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_9e94901167  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class Stat < ApplicationRecord
  class MangaGenreBreakdown < Stat
    include Stat::GenreBreakdown

    # for recalculate!
    def media_column
      :manga
    end

    # for class methods
    def self.media_type
      'Manga'
    end
  end
end
