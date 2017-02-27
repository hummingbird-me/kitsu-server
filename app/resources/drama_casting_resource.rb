class DramaCastingResource < BaseResource
  attributes :locale, :notes

  has_one :drama_character
  has_one :person
  has_one :licensor, class_name: 'Producer'
end
