class AlgoliaUsersIndex < BaseIndex
  self.index_name = 'users'

  attributes :name, :past_names
  attribute :followers_count, frequency: 2.5
end
