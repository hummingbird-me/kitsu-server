require 'rails_helper'

RSpec.describe LeaderChatMessage, type: :model do
  it { should belong_to(:group).required }
  it { should belong_to(:user).required }
end
