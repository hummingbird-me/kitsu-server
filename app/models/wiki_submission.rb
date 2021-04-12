class WikiSubmission < ApplicationRecord
  belongs_to :user
  has_many :logs, class_name: 'WikiSubmissionLog', dependent: :destroy

  belongs_to :parent, inverse_of: :child, foreign_key: :parent_id, optional: true
  has_one :child, inverse_of: :parent, dependent: :destroy

  enum status: {
    draft: 0,
    pending: 1,
    approved: 2,
    rejected: 3
  }
end
