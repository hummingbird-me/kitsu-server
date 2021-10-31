GraphQL::FancyLoader.configure do |config|
  config.middleware = [GraphQL::FancyLoader::PunditMiddleware.new(key: :token)]
end
