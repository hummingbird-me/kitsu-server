require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:post) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:text) }

  context 'without text' do
    subject { build(:post, text: '') }
    it { should validate_presence_of(:text_formatted) }
  end
end
