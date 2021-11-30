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
    null: false,
    description: 'The official or de facto international title'
  field :canonical_locale,
    String,
    null: true,
    description: 'The locale code that identifies which title is used as the canonical title'

  field :translated,
    String,
    null: true,
    description: "The title translated into the user's locale"
  field :translated_locale,
    String,
    null: true,
    description: 'The locale code that identifies which title is used as the translated title'

  field :romanized,
    String,
    null: true,
    description: 'The original title, romanized into latin script'
  field :romanized_locale,
    String,
    null: true,
    description: 'The locale code that identifies which title is used as the romanized title'

  field :original,
    String,
    null: true,
    description: 'The original title of the media in the original language'
  field :original_locale,
    String,
    null: true,
    description: 'The locale code that identifies which title is used as the original title'

  field :preferred,
    String,
    null: false,
    description: "The title that best matches the user's preferred settings"

  def preferred
    object.first_title_for(context[:user]&.title_preference_list || %i[canonical])
  end
end
