class Casting < ApplicationRecord
  belongs_to :media, polymorphic: true, touch: true
  belongs_to :character, touch: true, optional: true
  belongs_to :person, touch: true, optional: true

  validates :media, presence: true, polymorphism: { type: Media }
  # Require either character or person
  validates :character, presence: true, unless: :person
  validates :person, presence: true, unless: :character
end
