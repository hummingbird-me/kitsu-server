# frozen_string_literal: true

class Types::Errors::Validation < Types::Errors::Base
  description <<-DESC.squish
    The mutation failed validation. This is usually because the input provided was invalid in some
    way, such as a missing required field or an invalid value for a field. There may be multiple of
    this error, one for each failed validation, and the `path` will generally refer to a location in
    the input parameters, that you can map back to the input fields in your form. The recommended
    action is to display validation errors to the user, and allow them to correct the input and
    resubmit.
  DESC

  def self.for_record(record, transform_path: nil, prefix: nil)
    record.errors.map do |error|
      path = [error.attribute.to_s]
      message = error.message
      path = [prefix, *path] if prefix
      path = transform_path.nil? ? path : transform_path.call(path)
      build(path:, message:)
    end
  end

  def message
    object[:message]
  end
end
