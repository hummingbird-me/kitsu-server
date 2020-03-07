class Inputs::TitlesListInput < Inputs::BaseInputObject
  argument :localized, Types::Map, required: false
  argument :alternatives, [String], required: false
  argument :canonical_key, String, required: false
end
