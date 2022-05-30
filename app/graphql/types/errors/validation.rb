class Types::Errors::Validation < Types::Errors::Base
  def self.for_record(record, transform_path:)
    record.errors.flat_map do |key, message|
      path = transform_path.nil? ? [key.to_s] : transform_path.call([key.to_s])
      build({
        path: path,
        message: message
      })
    end
  end
end
