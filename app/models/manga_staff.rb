class MangaStaff < ApplicationRecord
  validates :role, length: { maximum: 140 }

  belongs_to :manga, required: true
  belongs_to :person, required: true
end
