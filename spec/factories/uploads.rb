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

include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :upload do
    user
    content { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'image.png'), 'image/png') }
  end
end
