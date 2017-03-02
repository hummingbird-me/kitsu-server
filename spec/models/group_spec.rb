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
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(4).is_at_most(50) }
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
end
