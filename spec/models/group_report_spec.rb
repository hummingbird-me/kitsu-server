require 'rails_helper'

RSpec.describe GroupReport, type: :model do
  subject { build(:group_report) }

  it { should define_enum_for(:reason) }
  it { should define_enum_for(:status) }
  it { should belong_to(:group).required }
  it { should belong_to(:naughty).required }
  it { should belong_to(:user).required }
  it { should belong_to(:moderator).class_name('User').optional }
  it { should validate_presence_of(:reason) }
  it { should validate_presence_of(:status) }

  context 'with a reason of other' do
    subject { build(:group_report, reason: :other) }
    it { should validate_presence_of(:explanation) }
  end
end
