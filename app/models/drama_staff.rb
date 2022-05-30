class DramaStaff < ApplicationRecord
  validates :role, length: { maximum: 140 }

  belongs_to :drama, optional: false
  belongs_to :person, optional: false
end
