# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: uploads
#
#  id                   :integer          not null, primary key
#  content_content_type :string
#  content_file_name    :string
#  content_file_size    :integer
#  content_updated_at   :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  comment_id           :integer          indexed
#  post_id              :integer          indexed
#  user_id              :integer          not null, indexed
#
# Indexes
#
#  index_uploads_on_comment_id  (comment_id)
#  index_uploads_on_post_id     (post_id)
#  index_uploads_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_127111e6ac  (post_id => posts.id)
#  fk_rails_15d41e668d  (user_id => users.id)
#  fk_rails_62b822a2d6  (comment_id => comments.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Upload, type: :model do
  subject { build(:upload) }
  it { should belong_to(:user) }
  it { should belong_to(:post) }
  it { should belong_to(:comment) }
end
