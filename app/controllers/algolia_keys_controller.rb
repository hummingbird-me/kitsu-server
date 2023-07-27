# frozen_string_literal: true

class AlgoliaKeysController < ApplicationController
  include CustomControllerHelpers

  def all
    render json: {
      users: json_for(User),
      media: json_for(Anime),
      groups: json_for(Group),
      characters: json_for(Character)
    }
  end

  def user
    render json: { users: json_for(User) }
  end

  def media
    render json: { media: json_for(Anime) }
  end

  def groups
    render json: { groups: json_for(Group) }
  end

  def characters
    render json: { characters: json_for(Character) }
  end

  private

  def json_for(klass)
    gen = generator_for(klass)
    { key: gen.key, index: gen.index }
  end

  def generator_for(klass)
    AlgoliaKeyService.new(klass, current_user)
  end
end
