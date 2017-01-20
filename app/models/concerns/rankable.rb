module Rankable
  DEFAULT_RANKINGS = {
    popularity_rank: :user_count,
    rating_rank: :average_rating
  }.freeze

  extend ActiveSupport::Concern

  class_methods do
    def update_rankings(rankings = DEFAULT_RANKINGS)
      rankings.each do |output_column, sort_column|
        ids = where.not(sort_column => nil).order(sort_column => :desc).ids
        ids.each_with_index do |id, index|
          where(id: id).update_all(output_column => index + 1)
        end
      end
    end
  end
end
