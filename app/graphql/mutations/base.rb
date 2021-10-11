class Mutations::Base < GraphQL::Schema::Mutation
  include BehindFeatureFlag

  def authorized?(record, action)
    return true if Pundit.policy!(context[:token], record).public_send(action)

    [false, {
      errors: [
        { message: message, code: 'NotAuthorized' }
      ]
    }]
  end

  def current_user
    User.current.presence || context[:user]
  end

  def self.default_graphql_name
    # Mutations::Anime::Create -> AnimeCreate
    # Mutations::LibraryEntry::UpdateStatusById -> LibraryEntryUpdateStatusById
    name.split('::')[1..-1].join
  end
end
