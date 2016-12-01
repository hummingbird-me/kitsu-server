class ApplicationController < JSONAPI::ResourceController
  include DoorkeeperHelpers
  include Pundit::ResourceController
  include MaintainIpAddresses

  def base_url
    super + '/api/edge'
  end

  before_action :validate_token!

  force_ssl if Rails.env.production?
end
