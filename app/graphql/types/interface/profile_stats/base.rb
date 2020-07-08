module Types::Interface::ProfileStats::Base
  include Types::Interface::Base
  description 'The basic stat information.'

  field :id, ID, null: false

  field :profile, Types::Profile,
    null: false,
    description: 'The profile related to the user for this stat.',
    method: :user

  field :recalculated_at, GraphQL::Types::ISO8601Date,
    null: false,
    description: 'Last time we fully recalculated this stat.'
end
