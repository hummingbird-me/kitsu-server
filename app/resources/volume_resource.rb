class VolumeResource < BaseResource
  attributes :title, :isbn

  has_one :manga
  has_many :chapters

  filter :manga_id
end
