require 'rails_helper'

RSpec.describe Accounts::GenerateNoltToken do
  let!(:user) { create(:user, :with_avatar) }

  it 'should correctly sign the JWT' do
    stub_const('Accounts::GenerateNoltToken::NOLT_SSO_SECRET', 'boo')
    token = described_class.call(user: user).token

    expect {
      JWT.decode(token, 'boo', true, { algorithm: 'HS256' })
    }.not_to raise_error
  end

  it 'should have the user email, id, name, and avatar' do
    stub_const('Accounts::GenerateNoltToken::NOLT_SSO_SECRET', 'boo')
    token = described_class.call(user: user).token
    contents = JWT.decode(token, 'boo', true, { algorithm: 'HS256' })[0]

    expect(contents['id']).to eq(user.id)
    expect(contents['email']).to eq(user.email)
    expect(contents['name']).to eq(user.name)
    expect(contents['imageUrl']).to eq(user.avatar(:original)&.url)
  end
end
