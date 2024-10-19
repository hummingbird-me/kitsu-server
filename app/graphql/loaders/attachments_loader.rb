class Loaders::AttachmentsLoader < GraphQL::FancyLoader
	from Upload
	sort :upload_order
end
