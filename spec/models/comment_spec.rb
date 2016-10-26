# == Schema Information
#
# Table name: comments
#
#  id                :integer          not null, primary key
#  blocked           :boolean          default(FALSE), not null
#  content           :text             not null
#  content_formatted :text             not null
#  deleted_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_id         :integer
#  post_id           :integer          not null
#  user_id           :integer          not null
#
# Foreign Keys
#
#  fk_rails_03de2dc08c  (user_id => users.id)
#  fk_rails_2fd19c0db7  (post_id => posts.id)
#  fk_rails_31554e7034  (parent_id => comments.id)
#

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:post).counter_cache(true) }
  it { should belong_to(:parent).class_name('Comment') }
  it { should belong_to(:user) }
  it { should have_many(:replies).class_name('Comment') }
  it { should validate_presence_of(:content) }

  it 'should convert basic markdown to fill in content_formatted' do
    comment = create(:comment, content: '*Emphasis* is cool!')
    expect(comment.content_formatted).to include('<em>')
  end

  it 'should not allow grandchildren' do
    grandparent = build(:comment)
    parent = build(:comment, parent: grandparent)
    comment = build(:comment, parent: parent)
    expect(comment).not_to be_valid
    expect(comment.errors[:parent]).to be_present
  end
end
