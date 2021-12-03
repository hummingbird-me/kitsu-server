class Drama < ApplicationRecord
  include Media
  include AgeRatings
  include Episodic

  enum subtype: %i[drama movie special]
  has_many :media_attributes, through: :dramas_media_attributes
  has_many :dramas_media_attributes
end
