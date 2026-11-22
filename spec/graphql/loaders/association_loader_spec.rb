# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Loaders::AssociationLoader do
  it 'batch-loads an association which is not already loaded' do
    anime = create(:anime)
    link = create(:streaming_link, media: anime)

    links = GraphQL::Batch.batch do
      described_class.for(Anime, :streaming_links).scope(Anime.find(anime.id)).then(&:to_a)
    end

    expect(links).to eq([link])
  end
end
