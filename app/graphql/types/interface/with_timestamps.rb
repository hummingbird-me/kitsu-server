module Types::Interface::WithTimestamps
  include Types::Interface::Base

  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
end
