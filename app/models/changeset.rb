class Changeset < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :subject, polymorphic: true

  enum status: %i[submitted accepted partially_accepted rejected]
end
