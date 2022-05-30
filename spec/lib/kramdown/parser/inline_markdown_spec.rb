require 'rails_helper'

RSpec.describe Kramdown::Parser::InlineMarkdown do
  it 'does not create headers' do
    text = '# Header'
    output = Kramdown::Document.new(text, input: 'InlineMarkdown').to_html
    expect(output).not_to include('<h1')
  end

  it 'creates paragraphs' do
    text = "two\n\nparagraphs"
    output = Kramdown::Document.new(text, input: 'InlineMarkdown').to_html
    paragraph_count = output.scan('<p').count
    expect(paragraph_count).to eq(2)
  end
end
