class MappingResource < BaseResource
  attributes :external_site, :external_id
  has_one :item, polymorphic: true

  filter :external_site
  filter :external_id
end
