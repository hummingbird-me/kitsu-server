class Types::PostFollow < Types::BaseObject
  implements Types::Interface::WithTimestamps

	field :post, Types::Post,
		null: false,
		description: 'The parent post'
	
	field :profile, Types::Profile,
		method: :user,
		null: false,
		description: 'The profile of the user who followed the post.'
end