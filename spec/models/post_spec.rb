require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { build(:post) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:target).class_name('User') }
  it { should validate_presence_of(:text) }
  it { should belong_to(:media) }
  it { should belong_to(:spoiled_unit) }

  context 'with a spoiled unit' do
    subject { build(:post, spoiled_unit: build(:episode)) }
    it { should validate_presence_of(:media) }
    it { should allow_value(true).for(:spoiler) }
    it { should_not allow_value(false).for(:spoiler) }
  end

  context 'without text' do
    subject { build(:post, text: '') }
    it { should validate_presence_of(:text_formatted) }
  end
end
