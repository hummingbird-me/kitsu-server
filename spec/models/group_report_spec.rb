require 'rails_helper'

RSpec.describe GroupReport, type: :model do
  subject { build(:group_report) }

  it { is_expected.to define_enum_for(:reason) }
  it { is_expected.to define_enum_for(:status) }
  it { is_expected.to belong_to(:group).required }
  it { is_expected.to belong_to(:naughty).required }
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:moderator).class_name('User').optional }
  it { is_expected.to validate_presence_of(:reason) }
  it { is_expected.to validate_presence_of(:status) }

  context 'with a reason of other' do
    subject { build(:group_report, reason: :other) }

    it { is_expected.to validate_presence_of(:explanation) }
  end
end
