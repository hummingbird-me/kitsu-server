class VideosController < ApplicationController
  def context
    super.merge(
      country: request.headers['CF-IPCountry']
    )
  end
end
