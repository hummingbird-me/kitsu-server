require_dependency 'stream/custom_endpoint_client'

class RecommendationsService
  class Media
    attr_reader :client, :user

    def inititalize(user)
      @client = Stream::CustomEndpointClient.new
      @user = user
    end

    def poll
      client.get "poll/#{user.id}/"
    end

    def recommendations_for(klass)
      client.get "recommendations/#{user.id}/"
    end

    def strength
      client.get "profile_strength/#{user.id}/"
    end
  end
end
