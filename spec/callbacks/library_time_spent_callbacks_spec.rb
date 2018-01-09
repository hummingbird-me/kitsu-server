require 'rails_helper'

RSpec.describe LibraryTimeSpentCallbacks do
  class LibraryEntryDouble
    include ActiveModel::Dirty

    attr_accessor :progress, :reconsume_count, :time_spent, :media
    define_attribute_methods :progress, :reconsume_count

    def initialize(progress: nil, reconsume_count: nil)
      @progress = progress
      @reconsume_count = reconsume_count
    end
  end
  let(:entry) { LibraryEntryDouble.new(progress: 5, reconsume_count: 5) }
  subject { described_class.new(entry) }

  describe '#before_save' do
    context 'with progress changed' do
      before { entry.progress_will_change! }

      context 'in a positive direction' do
        before do
          entry.progress += 5
          # Set up the chain of entry.media.episodes.for_range(range).sum(:length)
          allow(entry).to receive_message_chain(:media, :episodes, :for_range, :sum) { 20 }
        end

        it 'should increment time_spent' do
          entry.time_spent = 5
          expect {
            subject.before_save
          }.to change(entry, :time_spent).by(20)
        end
      end

      context 'in a negative direction' do
        before do
          entry.progress -= 5
          # Set up the chain of entry.media.episodes.for_range(range).sum(:length)
          allow(entry).to receive_message_chain(:media, :episodes, :for_range, :sum) { 20 }
        end

        it 'should decrement time_spent' do
          entry.time_spent = 25
          expect {
            subject.before_save
          }.to change(entry, :time_spent).by(-20)
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
          allow(entry).to receive_message_chain(:media, :total_length) { 300 }
        end

        it 'should increment time_spent by the total length of the media' do
          entry.time_spent = 0
          expect {
            subject.before_save
          }.to change(entry, :time_spent).by(600)
        end
      end

      context 'in a negative direction' do
        before do
          entry.reconsume_count -= 2
          # Set up the chain of entry.media.total_length
          allow(entry).to receive_message_chain(:media, :episodes) { [] }
          allow(entry).to receive_message_chain(:media, :total_length) { 300 }
        end

        it 'should increment time_spent by the total length of the media' do
          entry.time_spent = 0
          expect {
            subject.before_save
          }.to change(entry, :time_spent).by(-600)
        end
      end
    end
  end

  context '.hook(klass)' do
    it 'should call before_save on the class, passing itself' do
      target = double('LibraryEntry')
      expect(target).to receive(:before_save).with(described_class)
      described_class.hook(target)
    end
  end
end
