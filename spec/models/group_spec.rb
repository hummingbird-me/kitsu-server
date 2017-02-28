# == Schema Information
#
# Table name: groups
#
#  id                       :integer          not null, primary key
#  about                    :text             default(""), not null
#  avatar_content_type      :string(255)
#  avatar_file_name         :string(255)
#  avatar_file_size         :integer
#  avatar_processing        :boolean          default(FALSE), not null
#  avatar_updated_at        :datetime
#  cover_image_content_type :string(255)
#  cover_image_file_name    :string(255)
#  cover_image_file_size    :integer
#  cover_image_updated_at   :datetime
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
#  tags                     :string           default([]), not null, is an Array
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_groups_on_slug  (slug) UNIQUE
#

require 'rails_helper'

RSpec.describe Group, type: :model do
  subject { build(:group) }

  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(4).is_at_most(50) }
  it { should define_enum_for(:privacy) }
  it { should have_many(:members).dependent(:destroy) }
  it { should have_many(:neighbors).dependent(:destroy) }

  it 'should send the follow to Stream on save' do
    expect(subject.aggregated_feed).to receive(:follow).with(subject.feed)
    expect(Feed.global).to receive(:follow).with(subject.feed)
    subject.save!
  end

  it 'should remove the follow from Stream on save' do
    subject.save!
    expect(subject.aggregated_feed).to receive(:unfollow).with(subject.feed)
    expect(Feed.global).to receive(:unfollow).with(subject.feed)
    subject.destroy!
  end
end
