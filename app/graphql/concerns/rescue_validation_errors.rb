module RescueValidationErrors
  extend ActiveSupport::Concern

  def resolve(*args, **kwargs)
    super
  rescue ActiveRecord::RecordInvalid => e
    errors = e.record.errors.map do |attribute, message|
      {
        code: 'ValidationError',
        message: e.record.errors.full_message(attribute, message),
        path: ['attributes', attribute.to_s.camelize(:lower)]
      }
    end

    { errors: errors }
  end
end
