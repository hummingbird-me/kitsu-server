class Types::Enum::Base < GraphQL::Schema::Enum
  def self.default_graphql_name
    "#{super}Enum"
  end
end
