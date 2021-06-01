class Types::Input::Base < GraphQL::Schema::InputObject
  def self.default_graphql_name
    # Types::Input::Anime::Create -> AnimeCreate
    "#{name.split('::')[2..-1].join}Input"
  end

  def to_model
    to_h
  end

  def current_user
    User.current
  end
end
