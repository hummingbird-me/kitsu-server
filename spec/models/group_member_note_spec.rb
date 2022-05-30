require 'rails_helper'

RSpec.describe GroupMemberNote, type: :model do
  it { is_expected.to belong_to(:group_member).required }
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to validate_presence_of(:content) }
end
