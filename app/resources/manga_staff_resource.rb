class MangaStaffResource < BaseResource
  attribute :role

  has_one :manga
  has_one :person
end
