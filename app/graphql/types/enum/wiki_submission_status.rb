class Types::Enum::WikiSubmissionStatus < Types::Enum::Base
  value 'DRAFT', '', value: 'draft'
  value 'PENDING', '', value: 'pending'
  value 'APPROVED', '', value: 'approved'
  value 'REJECTED', '', value: 'rejected'
end
