Raven.configure do |config|
  config.silence_ready = true
  config.excluded_exceptions += [
    'Rack::Utils::InvalidParameterError', # Rack was unable to decode a parameter
  ]
end
