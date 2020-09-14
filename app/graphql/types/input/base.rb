class Types::Input::Base < GraphQL::Schema::InputObject
  OPERATION = %w[sort create update delete].freeze

  # These need to be unique, so I am forcible doing that.
  # I am thou, and thou art I, but you will always be an input!
  def self.default_graphql_name
    split_name = name.split('::')[2..-1]

    if split_name.last.downcase.starts_with?(*OPERATION)
      # Used so that it will throw an error if name.nil?
      super
      # Types::Input::Anime::Create -> AnimeCreate
      "#{split_name.join}Input"
    else
      "#{super}Input"
    end
  end
end
