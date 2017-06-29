class LibraryEventResource < BaseResource
  immutable

  attributes :notes, :nsfw, :private, :progress, :rating, :reconsuming,
    :reconsume_count, :volumes_owned, :time_spent, :status, :event,
    :changed_data

  has_one :library_entry
  has_one :user
  has_one :anime
  has_one :manga
  has_one :drama

  filter :user_id
  # TODO: is this filter needed?
  # I think it will need to have lambda attached
  filter :created_at
end
