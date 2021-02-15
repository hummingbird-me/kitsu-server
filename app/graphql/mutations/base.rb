class Mutations::Base < GraphQL::Schema::Mutation
  include BehindFeatureFlag

  def authorized?(record, action)
    return true if Pundit.policy!(context[:token], record).public_send(action)

    [false, Errors::Pundit::NotAuthorizedError.graphql_error]
  end

  def current_user
    User.current
  end

  def self.default_graphql_name
    # Mutations::Anime::Create -> AnimeCreate
    # Mutations::LibraryEntry::UpdateStatusById -> LibraryEntryUpdateStatusById
    name.split('::')[1..-1].join
  end
end
