require 'rails_helper'

RSpec.describe Report, type: :model do
  subject { build(:report) }

  it { should define_enum_for(:reason).with_values(%i[nsfw offensive spoiler bullying other spam]) }
  it { should define_enum_for(:status).with_values(%i[reported resolved declined]) }
  it { should belong_to(:naughty).required }
  it { should belong_to(:user).required }
  it { should belong_to(:moderator).class_name('User').optional }
  it { should validate_presence_of(:reason) }
  it { should validate_presence_of(:status) }

  context 'with a reason of other' do
    subject { build(:report, reason: :other) }
    it { should validate_presence_of(:explanation) }
  end
end
