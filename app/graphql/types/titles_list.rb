class Types::TitlesList < Types::BaseObject
  include HasLocalizedField

  localized_field :localized,
    description: 'The list of localized titles keyed by locale'
  field :alternatives,
    [String],
    null: true,
    description: 'A list of additional, alternative, abbreviated, or unofficial titles'
  field :canonical,
    String,
    null: true,
    description: 'The official or de facto international title'
  field :canonical_locale,
    String,
    null: true,
    description: 'The locale code that identifies which title is used as the canonical title'
end
