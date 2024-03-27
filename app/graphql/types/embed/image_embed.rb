class Types::Embed::ImageEmbed < Types::BaseObject
	field :url, String,
		null: false

	field :type, String,
		null: true

	field :width, Integer,
		null: true

	field :height, Integer,
		null: true
	
	field :alt, String,
		null: true
end