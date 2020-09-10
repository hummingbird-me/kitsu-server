class Types::Input::Base < GraphQL::Schema::InputObject
  CRUD_OPERATION = %w[create update delete].freeze

  # NOTE: https://github.com/rmosolgo/graphql-ruby/blob/master/lib/graphql/schema/input_object.rb#L136
  # These need to be unique, so I am forcible doing that.
  # I am thou, and thou art I, but you will always be an input!
  def self.graphql_name(new_name = nil)
    return super(new_name) if new_name.present?

    split_name = name.split('::')[2..-1]

    if CRUD_OPERATION.exclude?(split_name.last.downcase)
      "#{super}Input"
    else
      # Types::Input::Anime::Create -> AnimeCreate
      "#{super(split_name.join)}Input"
    end
  end
end
