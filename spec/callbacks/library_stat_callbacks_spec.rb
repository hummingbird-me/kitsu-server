require 'rails_helper'

RSpec.describe LibraryStatCallbacks do
  subject(:callbacks) { described_class.new(entry) }

  let(:anime) { build(:anime) }
  let(:manga) { build(:manga) }
  let(:user) { create(:user) }

  def include_a_job_matching(*args)
    include(a_hash_including('args' => args))
  end

  context 'with Manga' do
    let(:entry) { build(:library_entry, manga: manga, user: user) }

    before do
      stub_const('StatWorker', class_spy(StatWorker))
    end

    describe '#after_update' do
      it 'queues a worker to update Stat::MangaCategoryBreakdown' do
        callbacks.after_update
        expect(StatWorker).to have_received(:perform_async)
          .with('Stat::MangaCategoryBreakdown', user, :update, entry)
      end

      it 'queues a worker to update Stat::MangaAmountConsumed' do
        callbacks.after_update
        expect(StatWorker).to have_received(:perform_async)
          .with('Stat::MangaAmountConsumed', user, :update, entry)
      end
    end

    describe '#after_create' do
      it 'queues a worker to create Stat::MangaCategoryBreakdown' do
        callbacks.after_create
        expect(StatWorker).to have_received(:perform_async)
          .with('Stat::MangaCategoryBreakdown', user, :create, entry)
      end

      it 'queues a worker to create Stat::MangaAmountConsumed' do
        callbacks.after_create
        expect(StatWorker).to have_received(:perform_async)
          .with('Stat::MangaAmountConsumed', user, :create, entry)
      end
    end

    describe '#after_destroy' do
      it 'queues a worker to destroy Stat::MangaCategoryBreakdown' do
        callbacks.after_destroy
        expect(StatWorker).to have_received(:perform_async)
          .with('Stat::MangaCategoryBreakdown', user, :destroy, entry)
      end

      it 'queues a worker to destroy Stat::MangaAmountConsumed' do
        callbacks.after_destroy
        expect(StatWorker).to have_received(:perform_async)
          .with('Stat::MangaAmountConsumed', user, :destroy, entry)
      end
    end
  end

  context 'with Anime' do
    let(:entry) { build(:library_entry, anime: anime, user: user) }

    before do
      stub_const('StatWorker', class_spy(StatWorker))
    end

    describe '#after_update' do
      it 'queues a worker to update Stat::AnimeCategoryBreakdown' do
        callbacks.after_update
        expect(StatWorker).to have_received(:perform_async)
          .with('Stat::AnimeCategoryBreakdown', user, :update, entry)
      end

      it 'queues a worker to update Stat::AnimeAmountConsumed' do
        callbacks.after_update
        expect(StatWorker).to have_received(:perform_async)
          .with('Stat::AnimeAmountConsumed', user, :update, entry)
      end
    end

    describe '#after_create' do
      it 'queues a worker to create Stat::AnimeCategoryBreakdown' do
        callbacks.after_create
        expect(StatWorker).to have_received(:perform_async)
          .with('Stat::AnimeCategoryBreakdown', user, :create, entry)
      end

      it 'queues a worker to create Stat::AnimeAmountConsumed' do
        callbacks.after_create
        expect(StatWorker).to have_received(:perform_async)
          .with('Stat::AnimeAmountConsumed', user, :create, entry)
      end
    end

    describe '#after_destroy' do
      it 'queues a worker to destroy Stat::AnimeCategoryBreakdown' do
        callbacks.after_destroy
        expect(StatWorker).to have_received(:perform_async)
          .with('Stat::AnimeCategoryBreakdown', user, :destroy, entry)
      end

      it 'queues a worker to destroy Stat::AnimeAmountConsumed' do
        callbacks.after_destroy
        expect(StatWorker).to have_received(:perform_async)
          .with('Stat::AnimeAmountConsumed', user, :destroy, entry)
      end
    end
  end

  describe '.hook(klass)' do
    before do
      stub_const('LibraryEntry', class_spy(LibraryEntry))
    end

    it 'calls after_update on the class, passing itself' do
      described_class.hook(LibraryEntry)
      expect(LibraryEntry).to have_received(:after_update).with(described_class)
    end

    it 'calls after_create on the class, passing itself' do
      described_class.hook(LibraryEntry)
      expect(LibraryEntry).to have_received(:after_create).with(described_class)
    end

    it 'calls after_destroy on the class, passing itself' do
      described_class.hook(LibraryEntry)
      expect(LibraryEntry).to have_received(:after_destroy).with(described_class)
    end
  end
end
