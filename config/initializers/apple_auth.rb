AppleAuth.configure do |config|
  config.apple_client_id = ENV['APPLE_CLIENT_ID']
  config.apple_private_key = ENV['APPLE_PRIVATE_KEY']
  config.apple_key_id = ENV['APPLE_KEY_ID']
  config.apple_team_id = ENV['APPLE_TEAM_ID']
  config.redirect_uri = ENV['APPLE_REDIRECT_URI']
end
