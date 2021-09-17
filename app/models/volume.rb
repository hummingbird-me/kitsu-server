class Volume < ApplicationRecord
  include Titleable
  include UnitThumbnailUploader::Attachment(:thumbnail)
  include PaperclipShrineSynchronization

  has_attached_file :thumbnail
  belongs_to :manga
  has_many :chapters

  validates_attachment :thumbnail, content_type: {
    content_type: %w[image/jpg image/jpeg image/png]
  }
  validates :number, presence: true
  validates :chapters_count, presence: true
end
