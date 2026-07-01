module MediaCrutches
  extend ActiveSupport::Concern

  class_methods do
    # Filter out NSFW age ratings
    def sfw
      safe_ratings = AgeRatings::SAFE_AGE_RATINGS.map(&:downcase)
      age_ratings = AgeRatings::AGE_RATINGS.map(&:to_s).map(&:downcase)
      unsafe_ratings = age_ratings - safe_ratings
      filter(bool: { must_not: { terms: { age_rating: unsafe_ratings } } })
    end

    # Convert from [[id, name], ...] to id => [names...]
    def groupify(plucks)
      plucks.each.with_object({}) do |(id, name), out|
        (out[id] ||= []).push(name)
      end
    end

    # Get character names for a series
    def get_characters(type, ids)
      groupify Casting.joins(:character).where(media_id: ids, media_type: type)
        .distinct.pluck(:media_id, 'characters.name')
    end

    # Get person names for a series
    def get_people(type, ids)
      groupify Casting.joins(:person).where(media_id: ids, media_type: type)
        .distinct.pluck(:media_id, 'people.name')
    end

    # Get Streamers for a series
    def get_streamers(type, ids)
      groupify StreamingLink
        .joins(:streamer)
        .where(media_id: ids, media_type: type).distinct
        .pluck(:media_id, 'streamers.site_name')
    end
  end
end
