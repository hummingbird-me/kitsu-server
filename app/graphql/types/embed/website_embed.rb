# frozen_string_literal: true

class Types::Embed::WebsiteEmbed < Types::BaseObject
  include OptionalEmbedDescription
  implements Types::Interface::RequiredEmbed

  field :site_name, String,
    description: SITE_NAME_DESCRIPTION,
    null: false
end