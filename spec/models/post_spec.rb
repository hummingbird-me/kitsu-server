# == Schema Information
#
# Table name: posts
#
#  id                :integer          not null, primary key
#  blocked           :boolean          default(FALSE), not null
#  comments_count    :integer          default(0), not null
#  content           :text             not null
#  content_formatted :text             not null
#  deleted_at        :datetime
#  media_type        :string
#  nsfw              :boolean          default(FALSE), not null
#  post_likes_count  :integer          default(0), not null
#  spoiled_unit_type :string
#  spoiler           :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  media_id          :integer
#  spoiled_unit_id   :integer
#  target_group_id   :integer
#  target_user_id    :integer
#  user_id           :integer          not null
#
# Foreign Keys
#
#  fk_rails_5b5ddfd518  (user_id => users.id)
#  fk_rails_6fac2de613  (target_user_id => users.id)
#

require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { build(:post) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:target_user).class_name('User') }
  it { should validate_presence_of(:content) }
  it { should belong_to(:media) }
  it { should belong_to(:spoiled_unit) }
  it { should have_many(:post_likes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  context 'with a spoiled unit' do
    subject { build(:post, spoiled_unit: build(:episode)) }
    it { should validate_presence_of(:media) }
    it { should allow_value(true).for(:spoiler) }
    it { should_not allow_value(false).for(:spoiler) }
  end

  context 'without content' do
    subject { build(:post, content: '') }
    it { should validate_presence_of(:content_formatted) }
  end

  context 'with a media' do
    let(:media) { create(:anime) }
    subject { create(:post, media: media) }
    it 'should create an activity' do
      expect {
        subject.save!
      }.to change {
        Feed.media(subject.media_type, media.id).activities.to_a.size
      }.by(1)
    end
  end
end
