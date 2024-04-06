# frozen_string_literal: true

class Types::Story::MediaReactionStory < Types::BaseObject
  implements Types::Interface::Story

  field :media_reaction, Types::MediaReaction, null: false
end
