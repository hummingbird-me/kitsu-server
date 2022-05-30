require 'rails_helper'

RSpec.describe LeaderChatMessage, type: :model do
  it { is_expected.to belong_to(:group).required }
  it { is_expected.to belong_to(:user).required }
end
