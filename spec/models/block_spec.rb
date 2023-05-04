require 'rails_helper'

RSpec.describe Block, type: :model do
  it { should belong_to(:user).required }
  it { should belong_to(:blocked).class_name('User').required }

  describe '.between' do
    it 'returns a block from user_a against user_b' do
      user_a, user_b = create_list(:user, 2)
      described_class.create!(user: user_a, blocked: user_b)

      expect(described_class.between(user_a, user_b)).not_to be_empty
    end

    it 'returns a block from user_b against user_a' do
      user_a, user_b = create_list(:user, 2)
      described_class.create!(user: user_b, blocked: user_a)

      expect(described_class.between(user_a, user_b)).not_to be_empty
    end

    it 'does not catch a block between user_a and somebody else' do
      user_a, user_b, user_c = create_list(:user, 3)
      described_class.create!(user: user_a, blocked: user_c)

      expect(described_class.between(user_a, user_b)).to be_empty
    end

    it 'does not catch a block between user_b and somebody else' do
      user_a, user_b, user_c = create_list(:user, 3)
      described_class.create!(user: user_b, blocked: user_c)

      expect(described_class.between(user_a, user_b)).to be_empty
    end
  end
end
