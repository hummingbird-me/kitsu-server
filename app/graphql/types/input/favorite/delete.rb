class Types::Input::Favorite::Delete < Types::Input::Base
  argument :id, ID, required: true
  argument :item_id, ID, required: true
  argument :item_type, Types::Enum::FavoriteItem, required: true
end
