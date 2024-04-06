# frozen_string_literal: true

class Types::Story::PostStory < Types::BaseObject
  implements Types::Interface::Story

  field :post, Types::Post, null: false
end
