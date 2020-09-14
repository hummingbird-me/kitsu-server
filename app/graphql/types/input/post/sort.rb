class Types::Input::Post::Sort < Types::Input::Base
  argument :field, Types::Enum::Sort::Post, required: true
  argument :order, Types::Enum::Order, required: true
end
