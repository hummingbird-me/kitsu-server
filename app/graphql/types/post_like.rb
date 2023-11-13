class Types::PostLike < Types::BaseObject
  implements Types::Interface::WithTimestamps

	field :post, Types::Post,
		null: false,
		description: 'The parent post'
	
	field :profile, Types::Profile,
		method: :user,
		null: false,
		description: 'The profile of the user who liked the post.'
end