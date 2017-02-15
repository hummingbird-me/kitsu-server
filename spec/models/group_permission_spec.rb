# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: group_permissions
#
#  id              :integer          not null, primary key
#  permission      :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  group_member_id :integer          not null, indexed
#
# Indexes
#
#  index_group_permissions_on_group_member_id  (group_member_id)
#
# Foreign Keys
#
#  fk_rails_f60693a634  (group_member_id => group_members.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe GroupPermission, type: :model do
  it { should belong_to(:group_member) }
  it { should validate_presence_of(:group_member) }
  it { should define_enum_for(:permission) }
end
