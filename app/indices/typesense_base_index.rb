# frozen_string_literal: true

class TypesenseBaseIndex < Typesensual::Index
  schema do
    enable_nested_fields

    field 'created_at', type: 'object'
    field 'created_at.year', type: 'int32', facet: true, optional: true
    field 'created_at.month', type: 'int32', facet: true, optional: true
    field 'created_at.day', type: 'int32', facet: true, optional: true
    field 'created_at.timestamp', type: 'int64', optional: true

    # Locale-specific strings
    # Pulled from https://typesense.org/docs/0.24.0/api/collections.html#schema-parameters
    field '.*\.ja-.*', type: 'string*', locale: 'ja'
    field '.*\.zh-.*', type: 'string*', locale: 'zh'
    field '.*\.ko-.*', type: 'string*', locale: 'ko'
    field '.*\.th-.*', type: 'string*', locale: 'th'
    field '.*\.el-.*', type: 'string*', locale: 'el'
    field '.*\.ru-.*', type: 'string*', locale: 'ru'
    field '.*\.sr-.*', type: 'string*', locale: 'sr'
    field '.*\.uk-.*', type: 'string*', locale: 'uk'
    field '.*\.be-.*', type: 'string*', locale: 'be'
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
