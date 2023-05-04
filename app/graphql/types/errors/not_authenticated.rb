# frozen_string_literal: true

class Types::Errors::NotAuthenticated < Types::Errors::Base
  description <<-DESC.squish
    The mutation requires an authenticated logged-in user session, and none was provided or the
    session has expired. The recommended action varies depending on your application and whether you
    provided the bearer token in the `Authorization` header or not. If you did, you should probably
    attempt to refresh the token, and if that fails, prompt the user to log in again. If you did not
    provide a bearer token, you should just prompt the user to log in.
  DESC
end
