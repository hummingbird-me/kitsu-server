class Types::Report < Types::BaseObject
  implements Types::Interface::WithTimestamps

  description 'A report made by a user'

  field :id, ID, null: false

  field :reason, Types::Enum::ReportReason,
    null: false,
    description: 'The reason for why the report was made'

  field :status, Types::Enum::ReportStatus,
    null: false,
    description: 'The resolution status for this report'

  field :explanation, String,
    null: true,
    description: <<~DESCRIPTION.squish
      Additional information related to why the report was made.
      The most relevant results will be at the top.
    DESCRIPTION

  field :reporter, Types::Profile,
    null: false,
    description: 'The user who made this report',
    method: :user

  field :moderator, Types::Profile,
    null: true,
    description: 'The moderator who responded to this report'

  field :naughty, Types::Union::ReportItem,
    null: false,
    description: ''
end
