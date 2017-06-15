# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: linked_accounts
#
#  id                 :integer          not null, primary key
#  disabled_reason    :string
#  encrypted_token    :string
#  encrypted_token_iv :string
#  session_data       :text
#  share_from         :boolean          default(FALSE), not null
#  share_to           :boolean          default(FALSE), not null
#  sync_to            :boolean          default(FALSE), not null
#  type               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  external_user_id   :string           not null
#  user_id            :integer          not null, indexed
#
# Indexes
#
#  index_linked_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_166e103170  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe LinkedAccount::MyAnimeList do
  context 'validates' do
    describe '#verify_mal_credentials' do
      context 'with valid login' do
        it 'should have no errors' do
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
        it 'should have an error' do
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
