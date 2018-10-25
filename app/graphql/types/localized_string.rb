class Types::LocalizedString < Types::BaseObject
  field :locale, String,
    null: false,
    description: 'The IETF/BCP 47 locale tag for this string'
  field :text, String,
    null: false,
    description: 'The text value of this string'
end
