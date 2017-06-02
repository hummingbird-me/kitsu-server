class MediaAttribute < ActiveRecord::Base
  has_and_belongs_to_many :anime
  has_and_belongs_to_many :manga
  has_and_belongs_to_many :drama

  has_many :media_attribute_vote, dependent: :destroy
end
