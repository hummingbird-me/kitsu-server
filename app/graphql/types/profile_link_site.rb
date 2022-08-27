class Types::ProfileLinkSite < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'An external site that can be linked to a user.'

  field :id, ID, null: false

  field :name, String,
    null: false,
    description: 'Name of the external profile website.'

  field :validate_find, String,
    null: false,
    description: 'Regex pattern used to validate the profile link.'

  field :validate_replace, String,
    null: false,
    description: 'Pattern to be replaced after validation.'
end
