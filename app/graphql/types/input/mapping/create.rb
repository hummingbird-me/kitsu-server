class Types::Input::Mapping::Create < Types::Input::Base
  argument :external_site, Types::Enum::MappingExternalSite, required: true
  argument :external_id, ID, required: true

  # NOTE: waiting for Union Inputs to be allowed.
  # argument :item, Types::Union::MappingItem, required: true
  argument :item_id, ID, required: true
  argument :item_type, Types::Enum::MappingItem, required: true
end
