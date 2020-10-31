module Errors
  module ActiveRecord
    class RecordInvalid
      def self.graphql_error(error)
        record = error.record
        errors = record.errors.map do |attribute, message|
          {
            code: 'ValidationError',
            message: record.errors.full_message(attribute, message),
            path: ['attributes', attribute.to_s.camelize(:lower)]
          }
        end

        {
          errors: errors
        }
      end
    end
  end
end
