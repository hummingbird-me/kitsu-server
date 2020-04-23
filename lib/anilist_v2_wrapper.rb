# frozen_string_literal: true

require 'graphql/client'
require 'graphql/client/http'

module AnilistV2Wrapper
  GRAPHQL_API = 'https://graphql.anilist.co'

  HTTP = GraphQL::Client::HTTP.new(GRAPHQL_API) do
    def headers(context)
      { 'Content-Type': 'application/json' }
    end
  end

  Schema = GraphQL::Client.load_schema(HTTP)

  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end
