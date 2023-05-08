# frozen_string_literal: true

class Resolvers::LocalizedField < Resolvers::Base
  type Types::Map, null: false

  argument :locales, [String], required: false

  def resolve(locales: nil)
    if locales.present?
      if locales.include?('*')
        # If they passed a wildcard, they want it all
        localized_strings
      else
        # When locales are provided, we filter by those
        acceptable = available_locales.acceptable_for(locales:)
        localized_strings.slice(*acceptable)
      end
    else
      # When no locales are provided, we fall back to the Accept-Language header
      acceptable = available_locales.acceptable_for(locales: accept_languages)
      localized_strings.slice(*acceptable)
    end
  end

  private

  def accept_languages
    context[:accept_languages]
  end

  def available_locales
    @available_locales ||= PreferredLocale.new(available: localized_strings.keys)
  end

  def localized_strings
    @localized_strings ||= if object.is_a?(Hash)
      object[field.method_sym]
    elsif object.respond_to?(field.method_sym)
      object.public_send(field.method_sym)
    else
      raise <<~ERR
        Failed to implement localized field for #{field.owner.graphql_name}##{field.name}
      ERR
    end.transform_keys { |k| k.to_s.tr('_', '-') }
  end
end
