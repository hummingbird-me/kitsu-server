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
    description: 'Additional information related to why the report was made'

  field :reporter, Types::Profile,
    null: false,
    description: 'The user who made this report',
    method: :user

  field :moderator, Types::Profile,
    null: true,
    description: 'The moderator who responded to this report'

  field :naughty, Types::Union::ReportItem,
    null: false,
    description: 'The entity that the report is related to'
end
