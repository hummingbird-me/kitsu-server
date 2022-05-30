require 'rails_helper'

RSpec.describe LinkedAccount::MyAnimeList do
  context 'validates' do
    describe '#verify_mal_credentials' do
      context 'with valid login' do
        it 'has no errors' do
          list_sync = instance_double(ListSync::MyAnimeList)
          subject = described_class.new(
            type: 'LinkedAccount::MyAnimeList',
            external_user_id: 'toyhammered',
            token: 'fakefake'
          )
          allow(subject).to receive(:list_sync).and_return(list_sync)
          expect(list_sync).to receive(:logged_in?).and_return(true)
          subject.valid?
          expect(subject.errors[:token]).to be_empty
        end
      end

      context 'with invalid login' do
        it 'has an error' do
          list_sync = instance_double(ListSync::MyAnimeList)
          subject = described_class.new(
            type: 'LinkedAccount::MyAnimeList',
            external_user_id: 'toyhammered',
            token: 'fakefake'
          )
          allow(subject).to receive(:list_sync).and_return(list_sync)
          expect(list_sync).to receive(:logged_in?).and_return(false)
          subject.valid?
          expect(subject.errors[:token]).not_to be_empty
        end
      end
    end
  end
end
