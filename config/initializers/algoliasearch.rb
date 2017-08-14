if ENV['ALGOLIA_APP_ID'] && ENV['ALGOLIA_UPDATE_KEY']
  AlgoliaSearch.configuration = {
    application_id: ENV['ALGOLIA_APP_ID'],
    api_key: ENV['ALGOLIA_UPDATE_KEY']
  }
end
