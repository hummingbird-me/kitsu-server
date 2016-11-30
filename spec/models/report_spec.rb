require 'rails_helper'

RSpec.describe Report, type: :model do
  subject { build(:report) }

  it { should define_enum_for(:reason).with(%i[nsfw offensive spoiler bullying
                                                other]) }
  it { should define_enum_for(:status).with(%i[reported resolved declined]) }
  it { should belong_to(:naughty) }
  it { should validate_presence_of(:naughty) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:moderator).class_name('User') }
  it { should validate_presence_of(:reason) }
  it { should validate_presence_of(:status) }

  context 'with a reason of other' do
    subject { build(:report, reason: :other) }
    it { should validate_presence_of(:explanation) }
  end
end
