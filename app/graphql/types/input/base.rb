class Types::Input::Base < GraphQL::Schema::InputObject
  # These need to be unique, so I am forcible doing that.
  # I am thou, and thou art I, but you will always be an input!
  def self.default_graphql_name
    # Types::Input::Anime::Create -> AnimeCreate
    "#{name.split('::')[2..-1].join}Input"
  end

  def to_model
    to_h
  end

  def current_user
    User.current.presence || context[:user]
  end
end
