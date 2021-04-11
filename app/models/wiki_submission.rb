class WikiSubmission < ApplicationRecord
  belongs_to :user
  has_many :logs, class_name: 'WikiSubmissionLog', dependent: :destroy
  has_one :parent, foreign_key: :parent_id, class: 'WikiSubmission', optional: true,
                   dependent: :destroy, inverse_of: :wiki_submission

  enum status: {
    draft: 0,
    pending: 1,
    approved: 2,
    rejected: 3
  }
end
