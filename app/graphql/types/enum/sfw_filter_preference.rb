class Types::Enum::SfwFilterPreference < Types::Enum::Base
  value 'SFW', 'Hide All Adult Content', value: 'sfw'
  value 'NSFW_SOMETIMES', 'Limit to Following Feed', value: 'nsfw_sometimes'
  value 'NSFW_EVERYWHERE', 'Adult Content Everywhere', value: 'nsfw_everywhere'
end
