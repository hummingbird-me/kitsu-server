class DramasMediaAttribute < ApplicationRecord
  has_many :media_attribute_votes
  belongs_to :drama
  belongs_to :media_attribute
end
