class AnimeStaff < ApplicationRecord
  validates :role, length: { maximum: 140 }

  belongs_to :anime, required: true
  belongs_to :person, required: true
end
