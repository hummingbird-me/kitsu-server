require 'rails_helper'

RSpec.describe LibraryTimeSpentCallbacks do
  class LibraryEntryDouble
    include ActiveModel::Dirty

    attr_accessor :progress, :reconsume_count, :time_spent, :media

    define_attribute_methods :progress, :reconsume_count

    def initialize(progress: nil, reconsume_count: nil, time_spent: 0)
      @progress = progress
      @reconsume_count = reconsume_count
      @time_spent = time_spent
    end

    def recalculate_time_spent!; end
  end
  subject { described_class.new(entry) }

  let(:entry) { LibraryEntryDouble.new(progress: 5, reconsume_count: 5, time_spent: 4000) }

  before do
    allow(Kernel).to receive(:rand).and_return(1)
  end

  describe '#before_save' do
    context 'with progress changed' do
      before { entry.progress_will_change! }

      context 'in a positive direction' do
        before do
          entry.progress += 5
          # Set up the chain of entry.media.episodes.for_range(range).sum(:length)
          allow(entry).to receive_message_chain(:media, :episodes, :for_range, :sum) { 123 }
        end

        it 'increments time_spent by the sum of the episode lengths so far' do
          entry.time_spent = 5
          expect {
            subject.before_save
          }.to change(entry, :time_spent).by(123)
        end
      end

      context 'in a negative direction' do
        before do
          entry.progress -= 5
          # Set up the chain of entry.media.episodes.for_range(range).sum(:length)
          allow(entry).to receive_message_chain(:media, :episodes, :for_range, :sum) { 123 }
        end

        it 'decrements time_spent by the sum of the episode lengths so far' do
          entry.time_spent = 25
          expect {
            subject.before_save
          }.to change(entry, :time_spent).by(-123)
        end
      end
    end

    context 'with reconsume_count changed' do
      before { entry.reconsume_count_will_change! }

      context 'in a positive direction' do
        before do
          entry.reconsume_count += 2
          # Set up the chain of entry.media.total_length
          allow(entry).to receive_message_chain(:media, :episodes) { [] }
          allow(entry).to receive_message_chain(:media, :total_length) { 12_345 }
        end

        it 'increments time_spent by the total length of the media times reconsume_count' do
          entry.time_spent = 0
          expect {
            subject.before_save
          }.to change(entry, :time_spent).by(24_690)
        end
      end

      context 'in a negative direction' do
        before do
          entry.reconsume_count -= 2
          # Set up the chain of entry.media.total_length
          allow(entry).to receive_message_chain(:media, :episodes) { [] }
          allow(entry).to receive_message_chain(:media, :total_length) { 12_345 }
        end

        it 'decrements time_spent by the total length of the media times reconsume_count' do
          entry.time_spent = 0
          expect {
            subject.before_save
          }.to change(entry, :time_spent).by(-24_690)
        end
      end
    end
  end

  describe '.hook(klass)' do
    it 'calls before_save on the class, passing itself' do
      target = double('LibraryEntry')
      expect(target).to receive(:before_save).with(described_class)
      described_class.hook(target)
    end
  end
end
