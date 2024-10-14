class Types::Embed < Types::BaseObject
	field :kind, String,
		null: false,
		description: 'What kind of embed is this.'
	
	field :title, String,
		null: false,
		description: 'The title of this embed.'
	
	field :description, null: true,
		resolver: Resolvers::LocalizedField
	
	field :url, String, 
		null: false,
		description: 'The url of this embed.'
	
	field :site, Types::Embed::EmbedSite,
		null: false

	def site
		puts object["site"]
		object["site"]
	end

	field :image, Types::Embed::ImageEmbed,
		null: true
	
	def image
		return nil unless object["image"]
		object["image"]
	end

	field :video, Types::Embed::VideoEmbed,
		null: true
	
	def video
		return nil unless object["video"]
		object["video"]
	end

	field :audio, Types::Embed::AudioEmbed,
		null: true

	def audio
		return nil unless object["audio"]
		object["audio"]
	end
end