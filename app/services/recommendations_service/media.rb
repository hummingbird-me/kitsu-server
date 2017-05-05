require_dependency 'stream/custom_endpoint_client'

class RecommendationsService
  class Media
    attr_reader :client, :user

    def inititalize(user)
      @client = Stream::CustomEndpointClient.new
      @user = user
    end

    def poll
      client.get("poll/#{user.id}/")
    end

    def recommendations_for(klass)
      res = client.get("recommendations/#{user.id}/")
      reccs = res.body.dig('results', 'recommendations', 'media', klass.name)
      reccs = reccs.reduce(&:merge)
      media_ids = reccs.keys.map { |key| key.split(':').last.to_i }
      media = klass.find(media_ids).index_by { |m| "#{m.class.name}:#{m.id}" }
      reccs = reccs.transform_keys { |key| media[key] }
      reccs = reccs.transform_values { |val| val['score'] }
      reccs = reccs.sort_by(&:last).reverse
      reccs.map(&:first)
    end

    def strength
      client.get("profile_strength/#{user.id}/")
    end
  end
end
