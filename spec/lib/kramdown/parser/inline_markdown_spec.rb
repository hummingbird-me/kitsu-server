require 'rails_helper'

RSpec.describe Kramdown::Parser::InlineMarkdown do
  it 'should not create headers' do
    output = Kramdown::Document.new('# Header', input: 'InlineMarkdown').to_html
    expect(output).not_to include('h1')
  end
end
