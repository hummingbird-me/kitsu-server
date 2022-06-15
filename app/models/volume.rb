class Volume < ApplicationRecord
  include Titleable
  include UnitThumbnailUploader::Attachment(:thumbnail)

  belongs_to :manga, inverse_of: :volumes
  has_many :chapters, inverse_of: :volume

  validates :number, presence: true
  validates :chapters_count, presence: true
end
