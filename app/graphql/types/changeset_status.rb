class Types::ChangesetStatus < Types::BaseEnum
  value 'SUBMITTED',
    'The changes have been submitted and are waiting for review by a moderator',
    value: 'submitted'
  value 'ACCEPTED',
    'The changes have been reviewed by a moderator and accepted',
    value: 'accepted'
  value 'PARTIALLY_ACCEPTED',
    'The changes have been reviewed by a moderator who accepted it after making some adjustments',
    value: 'partially_accepted'
  value 'REJECTED',
    'The changes have been reviewed by a moderator who rejected them',
    value: 'rejected'
end
