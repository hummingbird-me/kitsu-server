# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MediaActivityService do
  subject { described_class.new(library_entry) }

  let(:library_entry) { build(:library_entry, user: create(:user)) }

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

  describe '#reviewed' do
    let(:review) { build(:review, library_entry:) }

    it 'returns an activity for the user\'s feed' do
      expect(subject.reviewed(review).feed)
        .to eq(library_entry.user.profile_feed)
    end
  end
end
