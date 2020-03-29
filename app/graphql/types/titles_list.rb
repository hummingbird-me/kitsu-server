class Types::TitlesList < Types::BaseObject
  include HasLocalizedField

  localized_field
    :localized,
    description: 'The list of localized titles keyed by locale'
  field :alternatives,
    [String],
    null: false,
    description: 'A list of additional, alternative, abbreviated, or unofficial titles'
  field :canonical,
    String,
    null: false,
    description: 'The official or de facto international title'
  field :canonical_locale,
    String,
    null: false,
    description: 'The locale code that identifies which title is used as the canonical title'
end
