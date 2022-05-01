module Types::Interface::Base
  extend ActiveSupport::Concern
  include GraphQL::Schema::Interface
  include HasImageField
  include HasLocalizedField
end
