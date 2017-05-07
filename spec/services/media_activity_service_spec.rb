require 'rails_helper'

RSpec.describe MediaActivityService do
  let(:library_entry) { build(:library_entry, user: build(:user, id: 1)) }

  subject { described_class.new(library_entry) }

  describe '#status' do
    it 'returns an activity for the user\'s feed' do
      expect(subject.status('current').feed)
        .to eq(library_entry.user.profile_feed)
    end
  end

  describe '#rating' do
    it 'returns an activity for the user\'s feed' do
      expect(subject.rating(5).feed)
        .to eq(library_entry.user.profile_feed)
    end
  end

  describe '#progress' do
    it 'returns an activity for the user\'s media feed' do
      expect(subject.progress(1).feed)
        .to eq(library_entry.user.profile_feed)
    end
  end

  describe '#reviewed' do
    let(:review) { build(:review, library_entry: library_entry) }

    it 'returns an activity for the user\'s feed' do
      expect(subject.reviewed(review).feed)
        .to eq(library_entry.user.profile_feed)
    end
  end
end
