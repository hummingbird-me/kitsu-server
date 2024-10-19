# frozen_string_literal: true

class TypesenseBaseIndex < Typesensual::Index
  schema do
    enable_nested_fields

    field 'created_at', type: 'object'
    field 'created_at.year', type: 'int32', facet: true, optional: true
    field 'created_at.month', type: 'int32', facet: true, optional: true
    field 'created_at.day', type: 'int32', facet: true, optional: true
    field 'created_at.timestamp', type: 'int64', optional: true
  end

  private

  def format_date(date)
    return { is_null: true } unless date
    {
      is_null: false,
      year: date.year,
      month: date.month,
      day: date.day,
      timestamp: date.to_time.to_i
    }
  end

  def format_image(image)
    return { is_null: true } unless image&.file

    views = image.derivatives.map do |(name, derivative)|
      {
        name:,
        url: derivative.url,
        width: derivative.width,
        height: derivative.height
      }.compact
    end

    {
      blurhash: image.file.blurhash,
      views:
    }.compact
  end
end
