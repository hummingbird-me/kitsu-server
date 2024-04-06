# frozen_string_literal: true

module Types::Interface::Story
  include Types::Interface::Base

  description 'A block in the feeds, containing 1 or more activities'

  field :bumped_at, GraphQL::Types::ISO8601DateTime, null: false
end
