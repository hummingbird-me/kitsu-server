class LibraryEventResource < BaseResource
  immutable

  attributes :changed_data, :kind, :created_at

  has_one :library_entry
  has_one :user
  has_one :anime
  has_one :manga
  has_one :drama

  filter :user_id
  filter :kind
end
