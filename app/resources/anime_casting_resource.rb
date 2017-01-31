class AnimeCastingResource < BaseResource
  attributes :locale, :notes

  has_one :anime_character
  has_one :person
  has_one :licensor, class_name: 'Producer'
end
