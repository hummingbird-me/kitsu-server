class Types::Input::Profile::Sort < Types::Input::Base
  argument :field, Types::Enum::Sort::Profile, required: true
  argument :order, Types::Enum::Order, required: true
end
