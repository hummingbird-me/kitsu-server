class ApplicationController < JSONAPI::ResourceController
  include DoorkeeperHelpers

  def base_url
    super + '/api/edge'
  end

  force_ssl if Rails.env.production?
end
