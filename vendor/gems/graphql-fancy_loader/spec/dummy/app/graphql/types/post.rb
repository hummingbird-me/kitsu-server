class Types::Post < Types::BaseField
  field :id, ID, null: false

  field :user, Types::User, null: false
  field :title, String, null: false
  field :description, String, null: true

  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
end
