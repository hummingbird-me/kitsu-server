class AnimeController < ApplicationController
  skip_after_action :enforce_policy_use, only: :languages

  def languages
    languages = Casting.where(media_id: params[:anime_id], media_type: 'Anime')
                       .distinct.pluck(:language).compact
    render json: languages
  end
end
