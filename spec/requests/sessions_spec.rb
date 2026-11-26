# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin login page' do
  def redirect_target(after)
    get '/api/sessions/new', params: { after: }
    Nokogiri::HTML(response.body).at('body')['data-redirect-to']
  end

  it 'keeps a path on this site' do
    expect(redirect_target('/api/sidekiq?poll=true')).to eq('/api/sidekiq?poll=true')
  end

  it 'reduces a full URL to its path' do
    expect(redirect_target('https://evil.tld/api/admin')).to eq('/api/admin')
  end

  [
    'javascript:alert(1)',
    'data:text/html,x',
    '//evil.tld',
    'https://kitsu.io//evil.tld',
    '/\\evil.tld',
    "/\t/evil.tld",
    nil
  ].each do |after|
    it "falls back to the admin panel for #{after.inspect}" do
      expect(redirect_target(after)).to eq('/api/admin')
    end
  end

  it 'sends an unauthenticated admin visit to the login page with a path' do
    get '/api/sidekiq'
    expect(response).to redirect_to('/api/sessions/new?after=%2Fapi%2Fsidekiq')
  end
end
