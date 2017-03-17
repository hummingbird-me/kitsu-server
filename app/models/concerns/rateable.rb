module Rateable
  extend ActiveSupport::Concern

  included do
    validates :average_rating, numericality: {
      less_than_or_equal_to: 10,
      greater_than_or_equal_to: 1
    }, allow_nil: true
  end

  def calculate_rating_frequencies
    base = LibraryEntry::VALID_RATINGS.map { |r| [r, 0] }.to_h
    freqs = LibraryEntry.where(media: self).group(:rating).count
                        .transform_keys(&:to_f)
                        .slice(*LibraryEntry::VALID_RATINGS)
    base.merge(freqs)
  end

  def calculate_rating_frequencies!
    update_attribute(:rating_frequencies, calculate_rating_frequencies)
  end

  def update_rating_frequency(rating, diff)
    return if rating.nil?
    update_query = <<-EOF
      rating_frequencies = rating_frequencies
        || hstore('#{rating}', (
          COALESCE(rating_frequencies->'#{rating}', '0')::integer + #{diff}
        )::text)
    EOF
    self.class.where(id: id).update_all(update_query)
    touch
  end

  def decrement_rating_frequency(rating)
    update_rating_frequency(rating, -1)
  end

  def increment_rating_frequency(rating)
    update_rating_frequency(rating, +1)
  end

  class_methods do
    def average_rating
      LibraryEntry.where(media: self).rated.average(:rating)
    end

    def update_average_ratings
      #
      # Bayesian rating:
      #
      #     r * v / (v + m) + c * m / (v + m)
      #
      #   where:
      #     r: average for the show
      #     votes: number of votes for the show
      #     min: minimum votes needed to display rating
      #     c: average across all shows
      #

      min = 50
      global_total_rating = 0
      global_total_votes  = 0
      media_total_ratings = {}
      media_total_votes   = {}

      find_each do |media|
        media_total_ratings[media.id] ||= 0
        media_total_votes[media.id] ||= 0

        media.rating_frequencies.each do |rating_s, count_s|
          next if rating_s == 'nil'

          rating = rating_s.to_f
          count = count_s.to_f

          next unless (rating % 0.5).zero?

          global_total_rating += rating * count
          global_total_votes += count

          media_total_ratings[media.id] += rating * count
          media_total_votes[media.id] += count
        end
      end

      c = global_total_rating * 1.0 / global_total_votes

      now = Time.now
      find_each do |media|
        votes = media_total_votes[media.id]
        if votes >= min
          r = media_total_ratings[media.id] * 1.0 / votes
          media.update_columns(
            average_rating: (r * votes + c * min) / (votes + min),
            updated_at: now
          )
        else
          media.update_columns(average_rating: nil, updated_at: now)
        end
      end
    end
  end
end
