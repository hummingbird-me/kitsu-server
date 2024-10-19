# frozen_string_literal: true

class Types::Attachment < Types::BaseObject
	implements Types::Interface::WithTimestamps

	field :id, ID, null: false

	field :owner_id, ID,
		null: false,
		description: 'The owner of this attachment.'

	field :owner_type, String,
		null: false,
		description: 'The type of the owner of this attachment.'

	field :author, Types::Profile,
		null: false,
		description: 'The author of this attachment.'

	def author
		Loaders::RecordLoader.for(User).load(object.user_id)
	end

	field :upload_order, Integer,
		null: false,
		description: 'The index of this attachment.'
	
	image_field :content,
		null: true,
		description: 'The actual content data.'
end