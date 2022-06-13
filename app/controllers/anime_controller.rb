class AnimeController < ApplicationController
  def languages
    model = Flipper[:media_castings].enabled?(User.current) ? MediaCasting : Casting
    languages = model.where(media_id: params[:anime_id], media_type: 'Anime')
                     .distinct.pluck(:language).compact
    render json: languages
  end
end
