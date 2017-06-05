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

    def realtime_recommendations_for(klass)
      res = client.get("realtime/#{user.id}/")
      reccs = res.body.dig('results', klass.name)
      enrich(klass, reccs)
    end

    def strength
      res = client.get("profile_strength/#{user.id}/")
      strengths = res.body.dig('results', 'profile_strength')
      strengths
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
