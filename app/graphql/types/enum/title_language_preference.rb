class Types::Enum::TitleLanguagePreference < Types::Enum::Base
  value 'CANONICAL', 'Prefer the most commonly-used title for media', value: 'canonical'
  value 'ROMANIZED', 'Prefer the romanized title for media', value: 'romanized'
  value 'LOCALIZED', 'Prefer the localized title for media', value: 'localized'
end
