# Feeds:
#   user/2 (flat) - Posts made by user/2
#   user_aggr/2 (aggregated) - Follows user by id for display
#   media/anime:8932 (flat) - Gets CC'd posts related to the media
#   media_aggr/anime:8932 (aggregated) - Follows media feed by id for display
#   group/1234 (flat) - Posts made in group/1234
#   group_aggr/1234 (aggregated) - Follows group by id for display
#   post/123456 (flat) - A feed of events occurring on a Post
#   timeline/2 (aggregated) - Follows user feeds for whoever we follow
#   notifications/2 (notifications) - Gets CC'd notifications for the user

if ENV['STREAM_API_KEY']
  StreamRails.configure do |config|
    config.api_key = ENV['STREAM_API_KEY']
    config.api_secret = ENV['STREAM_API_SECRET']
  end
end

StreamRails.configure do |config|
  config.timeout = 20
end

require 'stream/log_subscriber'
Stream::LogSubscriber.attach_to :getstream
