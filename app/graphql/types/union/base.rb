class Types::Union::Base < GraphQL::Schema::Union
  def self.graphql_name(new_name = nil)
    return super(new_name) if new_name.present?

    "#{super}Union"
  end
end
