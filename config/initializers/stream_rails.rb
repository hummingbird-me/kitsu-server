# Feeds:
#   user/2 (flat) - Posts made by user/2
#   user_aggr/2 (aggregated) - Follows user by id for display
#   media/anime:8932 (flat) - Gets CC'd posts related to the media
#   media_aggr/anime:8932 (aggregated) - Follows media feed by id for display
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
