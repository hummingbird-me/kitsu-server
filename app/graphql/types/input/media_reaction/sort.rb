class Types::Input::MediaReaction::Sort < Types::Input::Base
  argument :field, Types::Enum::Sort::MediaReaction, required: true
  argument :order, Types::Enum::Order, required: true
end
