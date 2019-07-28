class EmbedsController < ApplicationController
  def create
    url = params[:url]
    embed = EmbedService.new(url).as_json
    render json: embed
  end
end
