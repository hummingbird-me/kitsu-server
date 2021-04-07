class WikiSubmission < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :user

  enum type: {
    anime: 0,
    manga: 1
  }

  enum status: {
    draft: 0,
    pending: 1,
    approved: 2
  }

  enum action: {
    create: 0,
    update: 1,
    delete: 2
  }
end
