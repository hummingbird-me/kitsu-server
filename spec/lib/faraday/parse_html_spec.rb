require 'rails_helper'
require 'faraday/parse_html'

RSpec.describe Faraday::ParseHtml do
  subject { described_class.new(->(env) { Faraday::Response.new(env) }, {}) }
  let(:env) do
    {
      request: {},
      request_headers: Faraday::Utils::Headers.new,
      response_headers: Faraday::Utils::Headers.new
    }
  end

  it 'does not explode for invalid html' do
    ['{!', '"a"', 'true', 'null', '1'].each do |body|
      req = env.merge(body: body)
      expect { subject.call(req) }.not_to raise_error
    end
  end

  it 'should turn the body into a Nokogiri::HTML::Document' do
    body = '<html><body></body></html>'
    req = env.merge(body: body)
    result = subject.call(req)
    expect(result.body).to be_a(Nokogiri::HTML::Document)
  end
end
