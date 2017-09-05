module Rateable
  extend ActiveSupport::Concern
  MIN_RATINGS = 50

  included do
    validates :average_rating, numericality: {
      less_than_or_equal_to: 100,
      greater_than: 0
    }, allow_nil: true
  end

  def calculate_rating_frequencies
    base = LibraryEntry::VALID_RATINGS.map { |r| [r, 0] }.to_h
    freqs = LibraryEntry.where(media: self).group(:rating).count
                        .transform_keys(&:to_i)
                        .slice(*LibraryEntry::VALID_RATINGS)
    base.merge(freqs)
  end

  def calculate_rating_frequencies!
    update_attribute(:rating_frequencies, calculate_rating_frequencies)
  end

  def update_rating_frequency(rating, diff)
    return if rating.nil?
    class_name = self.class.name.to_s
    UpdateRatingFrequencyWorker.perform_async(class_name, id, rating, diff)
  end

  def decrement_rating_frequency(rating)
    update_rating_frequency(rating, -1)
  end

  def increment_rating_frequency(rating)
    update_rating_frequency(rating, +1)
  end

  class_methods do
    def update_average_ratings
      #
      # Bayesian rating:
      #
      #     (total + (MIN * global_average)) / (count + MIN)
      #
      #   where:
      #     total: sum of all ratings for this media
      #     count: number of ratings for this media
      #     MIN: minimum number of ratings needed to generate scores
      #     global_average: average across all media
      #
      # (total + (MIN * global_average)) / (count + MIN)

      ratings_total = 0
      ratings_count = 0
      media_ratings_total = Hash.new { 0 }
      media_ratings_count = Hash.new { 0 }

      # Technically, we could use aggregate functions in SQL, but they're
      # nowhere near as fast as this code, since they have to scan the entire
      # LibraryEntry table.
      select(:id, :rating_frequencies).find_each do |media|
        media.rating_frequencies.each do |rating, count|
          count = count.to_i
          rating = rating.to_i
          total = count * rating
          media_ratings_total[media.id] += total
          ratings_total += total
          media_ratings_count[media.id] += count
          ratings_count += count
        end
      end

      average_rating = ratings_total.to_f / ratings_count
      base = (average_rating * MIN_RATINGS)

      now = Time.now
      find_each do |media|
        media_count = media_ratings_count[media.id]
        if media_count >= MIN_RATINGS
          media_total = media_ratings_total[media.id]
          # Bayesian average on scale of 1..19
          raw_score = (media_total + base).to_f / (media_count + MIN_RATINGS)
          # Map to a scale of 5..100
          percent_score = (4 + (raw_score.to_f / 20) * 95)

          media.update_columns(
            average_rating: percent_score,
            updated_at: now
          )
        else
          media.update_columns(average_rating: nil, updated_at: now)
        end
      end
    end
  end
end
