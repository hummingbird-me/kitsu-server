class BaseResource < JSONAPI::Resource
  abstract
  include BackportFindRecords
  include AuthenticatedResource
  include AuthorizedResource
  include SearchableResource
end
