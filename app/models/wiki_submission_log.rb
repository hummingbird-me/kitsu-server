class WikiSubmissionLog < ApplicationRecord
  belongs_to :user
  belongs_to :wiki_submission

  enum status: {
    draft: 0,
    pending: 1,
    approved: 2,
    rejected: 3
  }
end
