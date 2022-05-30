require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { build(:comment, content: nil) }

  it { is_expected.to belong_to(:post).counter_cache(true).required }

  it {
    is_expected.to belong_to(:parent).class_name('Comment')
                                     .counter_cache('replies_count').optional
  }

  it { is_expected.to belong_to(:user).required }
  it { is_expected.to have_many(:replies).class_name('Comment').dependent(:destroy) }
  it { is_expected.to have_many(:likes).class_name('CommentLike').dependent(:destroy) }
  it { is_expected.to validate_length_of(:content).is_at_most(9_000) }

  context 'with content' do
    before { subject.content = 'some content' }

    it { is_expected.not_to validate_presence_of(:uploads).with_message('must exist') }
  end

  context 'with uploads' do
    before do
      subject.uploads = [build(:upload)]
      subject.content = nil
    end

    it { is_expected.not_to validate_presence_of(:content) }
  end

  it 'converts basic markdown to fill in content_formatted' do
    comment = create(:comment, content: '*Emphasis* is cool!')
    expect(comment.content_formatted).to include('<em>')
  end

  it 'does not allow grandchildren' do
    grandparent = build(:comment)
    parent = build(:comment, parent: grandparent)
    comment = build(:comment, parent: parent)
    expect(comment).not_to be_valid
    expect(comment.errors[:parent]).to be_present
  end

  context 'which is on AMA that is closed' do
    it 'is not valid' do
      post = create(:post)
      ama = create(:ama, original_post: post)
      ama.start_date = 6.hours.ago
      ama.end_date = ama.start_date + 1.hour
      ama.save
      comment = build(:comment, post: post)
      expect(comment).not_to be_valid
    end
  end
end
