# frozen_string_literal: true

module Types::Interface::Base
  extend ActiveSupport::Concern
  include GraphQL::Schema::Interface
  include HasImageField
end
