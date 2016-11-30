class Report < ApplicationRecord
  belongs_to :naughty, polymorphic: true, required: true
  belongs_to :user, required: true
  belongs_to :moderator, class_name: 'User', required: false

  enum reason: %i[nsfw offensive spoiler bullying other]
  enum status: %i[reported resolved declined]

  validates :explanation, presence: true, if: :other?
  validates :reason, :status, presence: true
end
