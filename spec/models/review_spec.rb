# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: reviews
#
#  id                :integer          not null, primary key
#  content           :text             not null
#  content_formatted :text             not null
#  legacy            :boolean          default(FALSE), not null
#  likes_count       :integer          default(0)
#  media_type        :string
#  progress          :integer
#  rating            :integer          not null
#  source            :string(255)
#  summary           :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  library_entry_id  :integer
#  media_id          :integer          not null, indexed
#  user_id           :integer          not null, indexed
#
# Indexes
#
#  index_reviews_on_media_id  (media_id)
#  index_reviews_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_150e554f22  (library_entry_id => library_entries.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Review, type: :model do
  subject { build(:review) }
  it { should have_many(:likes).class_name('ReviewLike') }
  it { should belong_to(:media) }
  it { should validate_presence_of(:media) }
  it 'should validate uniqueness per media and user' do
    subject.save!
    expect(subject).to validate_uniqueness_of(:media_id).scoped_to(:user_id)
  end
  it { should belong_to(:user).counter_cache(true) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:library_entry) }
  it { should validate_presence_of(:library_entry) }
  it { should validate_presence_of(:content) }

  context 'in a legacy review' do
    subject { build(:review, legacy: true) }
    it { should validate_presence_of(:summary) }
  end

  context 'in a new review' do
    subject { build(:review, legacy: false) }
    it { should validate_absence_of(:summary) }
  end
end
