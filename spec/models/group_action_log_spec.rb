require 'rails_helper'

RSpec.describe GroupActionLog, type: :model do
  it { is_expected.to belong_to(:target).required }
  it { is_expected.to belong_to(:group).required }
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to validate_presence_of(:verb) }
end
