class Types::Input::Favorite::Sort < Types::Input::Base
  argument :field, Types::Enum::Sort::Favorite, required: true
  argument :order, Types::Enum::Order, required: true
end
