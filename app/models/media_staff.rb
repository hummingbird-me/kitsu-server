class MediaStaff < ApplicationRecord
  belongs_to :media, polymorphic: true, optional: false, inverse_of: :staff
  belongs_to :person, optional: false
end
