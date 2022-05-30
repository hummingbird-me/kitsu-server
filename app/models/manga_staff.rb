class MangaStaff < ApplicationRecord
  validates :role, length: { maximum: 140 }

  belongs_to :manga, optional: false
  belongs_to :person, optional: false
end
