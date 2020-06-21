class Errors::Extensions < Types::BaseObject
  description 'Additional data about the error'

  field :code, String,
    null: false,
    description: 'The error code that was raised'

  field :timestamp, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'Time the error took place'
end
