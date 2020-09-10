class Types::Union::Base < GraphQL::Schema::Union
  def self.default_graphql_name
    "#{super}Union"
  end
end
