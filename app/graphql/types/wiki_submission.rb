class Types::WikiSubmission < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description ''

  field :id, ID, null: false

  field :status, Types::Enum::WikiSubmissionStatus,
    null: false,
    description: ''

  field :draft, GraphQL::Types::JSON,
    null: true,
    description: ''

  field :title, String,
    null: true,
    description: ''

  field :notes, String,
    null: true,
    description: ''

  field :author, Types::Profile,
    null: false,
    description: 'The user who created this draft',
    method: :user
end
