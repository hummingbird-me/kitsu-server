class Types::Embed::EmbedSite < Types::BaseObject
  field :name, String,
		null: false,
		description: 'The name of the embedded website.'
	
	field :url, String,
		null: true,
		description: 'The url of the embedded website.'
end