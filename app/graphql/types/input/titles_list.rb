class Types::Input::TitlesList < Types::Input::Base
  argument :canonical, String, required: false
  argument :localized, Types::Map, required: false
  argument :alternatives, [String], required: false
  argument :canonical_locale, String, required: false
end
