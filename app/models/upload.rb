class Upload < ApplicationRecord
  include RankedModel
  include AttachmentUploader::Attachment(:content)
  ranks :upload_order, with_same: %i[owner_type owner_id]

  belongs_to :user
  belongs_to :owner, polymorphic: true, optional: true
  validates :upload_order, presence: true, if: :owner_id?

  scope :orphan, -> {
    where(
      owner_type: nil,
      owner_id: nil
    ).where(
      ['created_at > ?', 11.hours.ago]
    )
  }
end
