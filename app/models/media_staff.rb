class MediaStaff < ApplicationRecord
  belongs_to :media, polymorphic: true, inverse_of: :staff
  belongs_to :person

  def rails_admin_label
    person.name
  end
end
