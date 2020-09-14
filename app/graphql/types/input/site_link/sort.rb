class Types::Input::SiteLink::Sort < Types::Input::Base
  argument :field, Types::Enum::Sort::SiteLink, required: true
  argument :order, Types::Enum::Order, required: true
end
