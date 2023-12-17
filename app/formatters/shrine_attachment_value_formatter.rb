# frozen_string_literal: true

class ShrineAttachmentValueFormatter < JSONAPI::ValueFormatter
  def self.format(value)
    return nil if value.blank?
    raise 'Invalid attachment field' unless value.is_a? Shrine::Attacher
    return nil if value.file.blank?

    Sentry.with_child_span(op: 'jsonapi.format_value',
      description: 'ShrineAttachmentValueFormatter') do |span|
      span.set_data(:record, value&.record&.to_global_id&.to_s)
      span.set_data(:name, value&.name&.to_s)

      output = value.derivatives.transform_values(&:url)
      output[:original] = value.file.url

      styles_dims = value.derivatives.transform_values do |derivative|
        {
          width: derivative.width,
          height: derivative.height
        }
      end
      output[:meta] = { dimensions: styles_dims }

      output
    end
  end
end
