class Types::CommentLike < Types::BaseObject
  implements Types::Interface::WithTimestamps

	field :comment, Types::Comment,
		null: false,
		description: 'The parent comment'
	
	field :profile, Types::Profile,
		method: :user,
		null: false,
		description: 'The profile of the user who liked the comment.'
end