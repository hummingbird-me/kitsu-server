class Drama < ApplicationRecord
  include Media
  include AgeRatings
  include Episodic

  enum subtype: { drama: 0, movie: 1, special: 2 }
  has_many :media_attributes, through: :dramas_media_attributes
  has_many :dramas_media_attributes
end
