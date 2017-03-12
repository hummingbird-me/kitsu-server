# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_member_notes
#
#  id                :integer          not null, primary key
#  content           :text             not null
#  content_formatted :text             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  group_member_id   :integer          not null
#  user_id           :integer          not null
#
# Foreign Keys
#
#  fk_rails_b689eab49d  (group_member_id => group_members.id)
#  fk_rails_ea0e9e51b1  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe GroupMemberNote, type: :model do
  it { should belong_to(:group_member) }
  it { should validate_presence_of(:group_member) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:content) }
end
