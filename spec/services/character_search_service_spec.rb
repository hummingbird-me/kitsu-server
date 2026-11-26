# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CharacterSearchService do
  def search(name)
    described_class.new({ name: [name] }, {})
  end

  it 'finds characters by their canonical name' do
    character = create(:character, name: 'Spike Spiegel')
    create(:character, name: 'Faye Valentine')

    expect(search('spike').to_a).to eq([character])
  end

  it 'finds characters by their name in another language' do
    character = create(:character, names: { en: 'Naruto Uzumaki', ja_jp: 'うずまき ナルト' })

    expect(search('ナルト').to_a).to eq([character])
  end

  it 'finds characters by one of their other names' do
    character = create(:character, name: 'Jet Black', other_names: ['Running Rock'])

    expect(search('running').to_a).to eq([character])
  end

  it 'finds a character by the name it was changed to' do
    character = create(:character, name: 'Before')
    character.update!(name: 'After')

    expect(search('after').to_a).to eq([character])
  end

  it 'leaves out characters which have been destroyed' do
    create(:character, name: 'Departed').destroy!

    expect(search('departed').to_a).to be_empty
  end

  it 'counts every match, not just the current page' do
    3.times { |i| create(:character, name: "Counted #{i}") }

    expect(search('counted').limit(2).total_count).to eq(3)
  end

  it 'pages through results by offset' do
    characters = Array.new(3) { |i| create(:character, name: "Paged #{i}") }

    pages = [0, 2].map { |offset| search('paged').offset(offset).limit(2).to_a }

    expect(pages.flatten).to match_array(characters)
  end
end
