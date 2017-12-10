# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: groups
#
#  id                       :integer          not null, primary key
#  about                    :text             default(""), not null
#  avatar_content_type      :string(255)
#  avatar_file_name         :string(255)
#  avatar_file_size         :integer
#  avatar_meta              :text
#  avatar_processing        :boolean          default(FALSE), not null
#  avatar_updated_at        :datetime
#  cover_image_content_type :string(255)
#  cover_image_file_name    :string(255)
#  cover_image_file_size    :integer
#  cover_image_meta         :text
#  cover_image_updated_at   :datetime
#  featured                 :boolean          default(FALSE), not null
#  last_activity_at         :datetime
#  leaders_count            :integer          default(0), not null
#  locale                   :string
#  members_count            :integer          default(0)
#  name                     :string(255)      not null
#  neighbors_count          :integer          default(0), not null
#  nsfw                     :boolean          default(FALSE), not null
#  privacy                  :integer          default(0), not null
#  rules                    :text
#  rules_formatted          :text
#  slug                     :string(255)      not null, indexed
#  tagline                  :string(60)
#  tags                     :string           default([]), not null, is an Array
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  category_id              :integer          not null, indexed
#  pinned_post_id           :integer
#
# Indexes
#
#  index_groups_on_category_id  (category_id)
#  index_groups_on_slug         (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_a61500b09c  (category_id => group_categories.id)
#  fk_rails_ae0dbbc874  (pinned_post_id => posts.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Group, type: :model do
  subject { build(:group) }

  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(3).is_at_most(50) }
  it { should define_enum_for(:privacy) }
  it do
    should have_many(:members).class_name('GroupMember').dependent(:destroy)
  end
  it do
    should have_many(:neighbors).class_name('GroupNeighbor').dependent(:destroy)
                                .with_foreign_key('source_id')
  end
  it do
    should have_many(:tickets).class_name('GroupTicket').dependent(:destroy)
  end
  it do
    should have_many(:invites).class_name('GroupInvite').dependent(:destroy)
  end
  it do
    should have_many(:reports).class_name('GroupReport').dependent(:destroy)
  end
  it { should have_many(:leader_chat_messages).dependent(:destroy) }
  it { should have_many(:bans).class_name('GroupBan').dependent(:destroy) }
  it do
    should have_many(:action_logs).class_name('GroupActionLog').dependent(:destroy)
  end
  it { should belong_to(:category).class_name('GroupCategory') }
  it { should validate_length_of(:tagline).is_at_most(60) }

  it 'should set up the feed on create' do
    feed = double('GroupFeed')
    allow(subject).to receive(:feed).and_return(feed)
    expect(feed).to receive(:setup!)
    subject.save!
  end
end
