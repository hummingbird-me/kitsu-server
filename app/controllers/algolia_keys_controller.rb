class AlgoliaKeysController < ApplicationController
  include CustomControllerHelpers

  def all
    render json: {
      users: json_for(User),
      posts: json_for(Post),
      media: json_for(Anime),
      groups: json_for(Group)
    }
  end

  def user
    render json: { users: json_for(User) }
  end

  def posts
    render json: { posts: json_for(Post) }
  end

  def media
    render json: { media: json_for(Anime) }
  end

  def groups
    render json: { groups: json_for(Group) }
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
