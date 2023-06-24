# frozen_string_literal: true

class Mutations::Favorite::Create < Mutations::Base
  include FancyMutation

  description 'Add a favorite entry.'

  input do
    argument :id, ID,
      required: true,
      description: 'The id of the entry'
    argument :type,
      Types::Enum::FavoriteType,
      required: true,
      description: 'The type of the entry.'
  end
  result Types::Favorite
  errors Types::Errors::NotAuthenticated,
    Types::Errors::NotFound,
    Types::Errors::NotAuthorized

  def ready?(type:, id:, **)
    authenticate!
    return errors << Types::Errors::NotAuthenticated.build if current_user.nil?
    case type
    when 'Anime'
      @item = Anime.find_by(id:)
    when 'Manga'
      @item = Manga.find_by(id:)
    when 'Character'
      @item = Character.find_by(id:)
    when 'Person'
      @item = Person.find_by(id:)
    end
    return errors << Types::Errors::NotFound.build(path: %w[input id]) if @item.nil?
    @favorite = Favorite.new(
      item_type: type,
      item_id: id,
      user_id: current_user.id
    )
    authorize!(@favorite, :create?)
    true
  end

  def resolve(**)
    @favorite.tap(&:save!)
  end
end
