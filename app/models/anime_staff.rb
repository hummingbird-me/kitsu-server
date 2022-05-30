class AnimeStaff < ApplicationRecord
  validates :role, length: { maximum: 140 }

  belongs_to :anime, optional: false
  belongs_to :person, optional: false
end
