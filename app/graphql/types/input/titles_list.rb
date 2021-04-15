class Types::Input::TitlesList < Types::Input::Base
  graphql_name 'TitlesListInput'

  argument :canonical, String, required: false
  argument :localized, Types::Map, required: false
  argument :alternatives, [String], required: false
  argument :canonical_locale, String, required: false
end
