require 'rails_helper'

RSpec.describe GroupMemberNote, type: :model do
  it { should belong_to(:group_member).required }
  it { should belong_to(:user).required }
  it { should validate_presence_of(:content) }
end
