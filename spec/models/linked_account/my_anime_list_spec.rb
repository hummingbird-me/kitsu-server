# == Schema Information
#
# Table name: linked_accounts
#
#  id                 :integer          not null, primary key
#  encrypted_token    :string
#  encrypted_token_iv :string
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

require 'rails_helper'

RSpec.describe LinkedAccount::MyAnimeList do
  subject { described_class.new }

  before do
    host = MyAnimeListSyncService::ATARASHII_API_HOST

    stub_request(:get, "#{host}account/verify_credentials")
      .with(
        headers: {
          Authorization: 'Basic dG95aGFtbWVyZWQ6ZmFrZWZha2U='
        }
      )
      .to_return(status: 200)
  end

  context 'validates' do
    describe '#verify_mal_credentials' do
      context 'with the server returning 200' do
        it 'should pass validation' do
          subject = described_class.new(
            sync_to: true,
            type: 'LinkedAccount::MyAnimeList',
            external_user_id: 'toyhammered',
            token: 'fakefake'
          )
          subject.valid?
          expect(subject.errors[:token]).to be_empty
        end
      end
    end
  end
end
