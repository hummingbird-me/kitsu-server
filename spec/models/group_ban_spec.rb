require 'rails_helper'

RSpec.describe GroupBan, type: :model do
  it { is_expected.to belong_to(:group).required }
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:moderator).class_name('User').required }
end
