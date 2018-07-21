class MediaStaff < ApplicationRecord
  belongs_to :media, polymorphic: true, required: true
  belongs_to :person, required: true
end
