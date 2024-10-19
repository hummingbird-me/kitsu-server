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
      nodes: Typesensual.client.configuration.nodes.map do |node|
        node.only(:port, :host, :protocol)
      end
    }
  end

  private

  def json_for(klass)
    gen = TypesenseKeyService.new(klass, doorkeeper_token)
    { key: gen.key, collection: gen.collection }
  end
end
