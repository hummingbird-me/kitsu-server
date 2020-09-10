class Types::Enum::Base < GraphQL::Schema::Enum
  def self.graphql_name(new_name = nil)
    return super(new_name) if new_name.present?

    "#{super}Enum"
  end
end
