class Volume < ApplicationRecord
  include Titleable
  include UnitThumbnailUploader::Attachment(:thumbnail)

  belongs_to :manga
  has_many :chapters

  validates :number, presence: true
  validates :chapters_count, presence: true
end
