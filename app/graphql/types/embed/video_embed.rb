class Types::Embed::VideoEmbed < Types::BaseObject
	field :url, String,
		null: false

	field :type, String,
		null: false

	field :width, Integer,
		null: true

	field :height, Integer,
		null: true
end