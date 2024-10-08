# frozen_string_literal: true

class TypesenseKeysController < ApplicationController
  include CustomControllerHelpers

  def all
    render json: {
      collections: {
        anime: json_for(Anime),
        manga: json_for(Manga),
        users: json_for(User)
      },
      nodes: Typesensual.client.configuration.nodes.only(:port, :host, :protocol)
    }
  end

  private

  def json_for(klass)
    gen = TypesenseKeyService.new(klass, doorkeeper_token)
    { key: gen.key, collection: gen.collection }
  end
end
