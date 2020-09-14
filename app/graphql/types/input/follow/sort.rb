class Types::Input::Follow::Sort < Types::Input::Base
  argument :field, Types::Enum::Sort::Follow, required: true
  argument :order, Types::Enum::Order, required: true
end
