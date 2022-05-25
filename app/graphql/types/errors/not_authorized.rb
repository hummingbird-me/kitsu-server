class Types::Errors::NotAuthorized < Types::Errors::Base
  field :action, String, null: true
end
