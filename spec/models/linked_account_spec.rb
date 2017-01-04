# == Schema Information
#
# Table name: linked_accounts
#
#  id                 :integer          not null, primary key
#  encrypted_token    :string
#  encrypted_token_iv :string
#  private            :boolean          default(TRUE), not null
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

RSpec.describe LinkedAccount, type: :model do
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

  subject { build(:linked_account)}

  it { should belong_to(:user) }
  it { should validate_presence_of(:external_user_id) }


  context 'validates' do
    # describe 'url' do
    #   context 'if private' do
    #     subject { described_class.new(private: true) }
    #     it { should validate_presence_of(:url) }
    #   end
    #   context 'if public' do
    #     subject { described_class.new(private: false) }
    #     it { should_not validate_presence_of(:url) }
    #   end
    # end
    describe '#verify_mal_credentials' do
      context '#sync_to_mal?' do
        it 'should pass validation' do
          subject = build(:linked_account,
            sync_to: true, type: 'LinkedAccount::MyAnimeList')
          expect(subject.sync_to_mal?).to be true
        end
        it 'should fail validation' do
          subject = build(:linked_account, sync_to: false)
          expect(subject.sync_to_mal?).to be false
        end
      end
    end
  end
end
