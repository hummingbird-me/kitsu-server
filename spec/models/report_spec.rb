require 'rails_helper'

RSpec.describe Report, type: :model do
  subject { build(:report) }

  it {
    is_expected.to define_enum_for(:reason).with_values(%i[nsfw offensive spoiler bullying other
                                                           spam])
  }

  it { is_expected.to define_enum_for(:status).with_values(%i[reported resolved declined]) }
  it { is_expected.to belong_to(:naughty).required }
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:moderator).class_name('User').optional }
  it { is_expected.to validate_presence_of(:reason) }
  it { is_expected.to validate_presence_of(:status) }

  context 'with a reason of other' do
    subject { build(:report, reason: :other) }

    it { is_expected.to validate_presence_of(:explanation) }
  end
end
