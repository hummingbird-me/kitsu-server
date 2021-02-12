class ErrorController < ApplicationController
  def not_found
    render status: :not_found, json: {
      errors: [{
        status: 404,
        title: 'Route Not Found'
      }]
    }
  end
end
