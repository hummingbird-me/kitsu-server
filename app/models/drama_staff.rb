class DramaStaff < ApplicationRecord
  validates :role, length: { maximum: 140 }

  belongs_to :drama, required: true
  belongs_to :person, required: true
end
