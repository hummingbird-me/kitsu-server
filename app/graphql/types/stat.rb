class Types::Stat < Types::BaseObject
  description 'The basic stat information.'

  field :id, ID, null: false

  field :profile, Types::Profile,
    null: false,
    description: 'The profile related to the user for this stat.',
    method: :user

  field :data, GraphQL::Types::JSON,
    null: false,
    description: 'The breakdown of this specific stat.',
    method: :stats_data

  field :recalculated_at, GraphQL::Types::ISO8601Date,
    null: false,
    description: 'Last time we fully recalculated this stat.'
end
