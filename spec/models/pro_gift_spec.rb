require 'rails_helper'

RSpec.describe ProGift, type: :model do
  it { should belong_to(:from).class_name('User') }
  it { should belong_to(:to).class_name('User') }
  it { should validate_length_of(:message).is_at_most(500) }

  describe '#duration' do
    context 'for a month of pro' do
      subject { ProGift.new(length: :month) }
      it 'should be 1 month of time' do
        expect(subject.duration).to eq(1.month)
      end
    end

    context 'for a year of pro' do
      subject { ProGift.new(length: :year) }
      it 'should be 1 year of time' do
        expect(subject.duration).to eq(1.year)
      end
    end
  end
end
