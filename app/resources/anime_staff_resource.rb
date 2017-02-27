class AnimeStaffResource < BaseResource
  attribute :role

  has_one :anime
  has_one :person
end
