class Types::Enum::Base < GraphQL::Schema::Enum
  OPERATIONS = %w[sort].freeze

  def self.default_graphql_name
    split_name = name.split('::')[2..-1]

    if split_name.first.downcase.starts_with?(*OPERATIONS)
      # Used so that it will throw an error if name.nil?
      super

      "#{split_name.join}Enum"
    else
      "#{super}Enum"
    end
  end
end
