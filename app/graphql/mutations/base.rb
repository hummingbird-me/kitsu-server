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
    context[:user]
  end

  def current_token
    context[:token]
  end

  def self.default_graphql_name
    # Mutations::Anime::Create -> AnimeCreate
    # Mutations::LibraryEntry::UpdateStatusById -> LibraryEntryUpdateStatusById
    name.split('::')[1..].join
  end
end
