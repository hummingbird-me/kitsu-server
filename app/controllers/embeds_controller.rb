class EmbedsController < ApplicationController
  skip_after_action :enforce_policy_use

  def create
    url = params[:url]
    embed = EmbedService.new(url).as_json
    render json: embed
  end
end
