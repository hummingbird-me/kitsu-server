class CharacterVoiceResource < BaseResource
  immutable
  attribute :locale

  has_one :media_character
  has_one :person
  has_one :licensor
end
