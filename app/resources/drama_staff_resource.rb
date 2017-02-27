class DramaStaffResource < BaseResource
  attribute :role

  has_one :drama
  has_one :person
end
