# frozen_string_literal: true

class Types::BaseObject < GraphQL::Schema::Object
  include HasImageField

  connection_type_class(Types::BaseConnection)

  private

  def current_user
    context[:user]
  end

  def current_token
    context[:token]
  end
end
