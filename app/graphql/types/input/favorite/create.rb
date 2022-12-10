class Types::Input::Favorite::Create < Types::Input::Base
	argument :item_id, ID, required: true
	argument :item_type, Types::Enum::FavoriteItem, required: true

	def to_model
    to_h.merge({ user_id: current_user&.id })
	end
end
  