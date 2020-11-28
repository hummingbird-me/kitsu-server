class Types::Embed::WebsiteEmbed < Types::BaseObject
  implements Types::Interface::BaseEmbed

  field :first_name, String,
    null: true,
    description: 'A name normally given to an individual by a parent or self-chosen.'

  field :last_name, String,
    null: true,
    description: <<~DESCRIPTION.squish
      A name inherited from a family or marriage
      and by which the individual is commonly known.
    DESCRIPTION

  field :username, String,
    null: true,
    description: 'A short unique string to identify them.'

  field :gender, Types::Enum::Gender,
    null: true,
    description: 'Their gender.'
end