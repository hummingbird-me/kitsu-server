require_dependency 'stream/custom_endpoint_client'

class RecommendationsService
  class Media
    attr_reader :client, :user

    def initialize(user)
      @client = Stream::CustomEndpointClient.new
      @user = user
    end

    def poll
      client.get("poll/#{user.id}/")
    end

    def recommendations_for(klass)
      res = client.get("recommendations/#{user.id}/")
      reccs = res.body.dig('results', 'recommendations', 'media', klass.name)
      enrich(klass, reccs)
    end

    def category_recommendations_for(klass)
      res = client.get("recommendations/#{user.id}/")
      reccs = res.body.dig(
        'results',
        'recommendations',
        'media',
        'Genre Recommendations'
      )
      enrich_category(klass, reccs)
    end

    def realtime_recommendations_for(klass)
      res = client.get("realtime/#{user.id}/")
      reccs = res.body.dig('results', klass.name)
      enrich(klass, reccs)
    end

    def realtime_category_recommendations_for(klass)
      res = client.get("realtime/#{user.id}/")
      reccs = res.body.dig('results', 'Genre Recommendations')
      enrich_category(klass, reccs)
    end

    def strength
      res = client.get("profile_strength/#{user.id}/")
      strengths = res.body.dig('results', 'profile_strength')
      strengths
    end

    def enrich_category(klass, reccs)
      reccs = reccs.reduce(&:merge)
      field_name = klass.model_name.i18n_key.to_s
      field_key = field_name.to_sym

      categories_objects = []
      reccs.each do |key, val|
        val = val.reduce(&:merge)
        media_ids = val.keys.map do |v_key|
          v_key.split(':').last.to_i if v_key.include? klass.model_name
        end
        media_ids.compact
        category_object = Category.includes(
          field_key
        ).where(
          field_key => { id: media_ids }
        ).find_by(id: key.to_i)
        next unless category_object
        j_category_object = category_object.as_json(include: field_key)
        j_category_object[field_name].sort_by do |e|
          media_ids.index(e[:id]) || media_ids.length
        end
        categories_objects << j_category_object
      end
      categories_objects
    end

    def enrich(klass, reccs)
      reccs = reccs.reduce(&:merge)
      media_ids = reccs.keys.map { |key| key.split(':').last.to_i }
      media = klass.find(media_ids).index_by { |m| "#{m.class.name}:#{m.id}" }
      reccs = reccs.transform_keys { |key| media[key] }
      reccs = reccs.transform_values { |val| val['score'] }
      reccs = reccs.sort_by(&:last).reverse
      reccs.map(&:first)
    end
  end
end
