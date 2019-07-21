class LibraryEventResource < BaseResource
  immutable

  attributes :changed_data, :kind

  has_one :library_entry
  has_one :user
  has_one :anime
  has_one :manga
  has_one :drama

  filter :user_id

  filter :kind, apply: ->(records, values, _opts) {
    values = values.map { |v| records.kinds[v] || v }
    records.where(kind: values)
  }
end
