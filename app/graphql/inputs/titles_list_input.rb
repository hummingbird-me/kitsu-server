class Inputs::TitlesListInput < Inputs::BaseInputObject
  argument :localized, Types::Map, required: false
  argument :alternatives, [String], required: false
  argument :canonical_locale, String, required: false
end
