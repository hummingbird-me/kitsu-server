# frozen_string_literal: true

RSpec.configure do |config|
  indices = [TypesenseAnimeIndex, TypesenseMangaIndex].freeze

  # Create a new collection for each index before each test and delete it afterwards. We also stub
  # it into place for the index instead of using aliases because the alias is updated
  # asynchronously.
  config.around do |example|
    RSpec::Mocks.with_temporary_scope do
      collections = indices.map do |index|
        collection = index.create!
        allow(index).to receive(:collection).and_return(collection)
        collection
      end

      example.run

      collections.each(&:delete!)
    end
  end
end
