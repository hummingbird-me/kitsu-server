class MediaStaff < ApplicationRecord
  belongs_to :media, polymorphic: true, required: true, inverse_of: :staff
  belongs_to :person, required: true
end
