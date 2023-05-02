# frozen_string_literal: true

class Types::Errors::Validation < Types::Errors::Base
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
