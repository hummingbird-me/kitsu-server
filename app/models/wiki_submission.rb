class WikiSubmission < ApplicationRecord
  belongs_to :user

  enum status: {
    draft: 0,
    approved: 1,
    rejected: 2
  }
end
