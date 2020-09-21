class Types::Input::Mapping::Update < Types::Input::Base
  argument :id, ID, required: true

  argument :external_site, Types::Enum::MappingExternalSite, required: false
  argument :external_id, ID, required: false
  argument :item_id, ID, required: false
  argument :item_type, Types::Enum::MappingItem, required: false
end
