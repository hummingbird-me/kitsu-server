# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: uploads
#
#  id                   :integer          not null, primary key
#  content_content_type :string
#  content_file_name    :string
#  content_file_size    :integer
#  content_meta         :text
#  content_updated_at   :datetime
#  owner_type           :string           indexed => [owner_id]
#  upload_order         :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  owner_id             :integer          indexed => [owner_type]
#  user_id              :integer          not null, indexed
#
# Indexes
#
#  index_uploads_on_owner_type_and_owner_id  (owner_type,owner_id)
#  index_uploads_on_user_id                  (user_id)
#
# Foreign Keys
#
#  fk_rails_15d41e668d  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

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
