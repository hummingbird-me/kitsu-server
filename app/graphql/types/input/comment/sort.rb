class Types::Input::Comment::Sort < Types::Input::Base
  argument :field, Types::Enum::Sort::Comment, required: true
  argument :order, Types::Enum::Order, required: true
end
