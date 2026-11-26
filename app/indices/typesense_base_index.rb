# frozen_string_literal: true

class TypesenseBaseIndex < Typesensual::Index
  schema do
    enable_nested_fields

    field 'created_at', type: 'int32', optional: true
  end

  private

  # A blank locale key becomes a field named `titles.`, and Typesense 30 then rejects every
  # document indexed after it ("Field `titles.` has an incorrect type").
  def format_localized(strings)
    strings.reject { |locale, _| locale.blank? }
  end

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
