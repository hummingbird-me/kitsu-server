module ErrorMapping
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |error|
      raise Errors::RecordNotFound, error.message
    end
  end
end
