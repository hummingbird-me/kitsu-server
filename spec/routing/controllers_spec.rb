# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes' do
  # JSONAPI::Resources routes every relationship to a controller named after the related resource,
  # and Rails answers a route whose controller is missing with a 500
  it 'all point at a controller which exists' do
    controllers = Rails.application.routes.routes.filter_map { |route| route.defaults[:controller] }
    missing = controllers.uniq.reject { |name| "#{name.camelize}Controller".safe_constantize }

    expect(missing).to be_empty
  end
end
