class Types::WikiSubmission < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description <<~DESCRIPTION.squish
    A Wiki Submission is used to either create or edit existing data in our database.
    This will allow a simple and convient way for users to submit issues/corrections without
    all the work being left to the mods.
  DESCRIPTION

  field :id, ID, null: false

  field :status, Types::Enum::WikiSubmissionStatus,
    null: false,
    description: 'The status of the Wiki Submission'

  field :data, GraphQL::Types::JSON,
    null: true,
    description: <<~DESCRIPTION.squish
      The full object that holds all the details for any modifications/additions/deletions
      made to the entity you are editing.
      This will be validated using JSON Schema.
    DESCRIPTION

  field :title, String,
    null: true,
    description: <<~DESCRIPTION.squish
      The title given to the Wiki Submission.
      This will default to the title of what is being edited.
    DESCRIPTION

  field :notes, String,
    null: true,
    description: 'Any additional information that may need to be provided related to the Wiki Submission'

  field :author, Types::Profile,
    null: false,
    description: 'The user who created this draft',
    method: :user
end
