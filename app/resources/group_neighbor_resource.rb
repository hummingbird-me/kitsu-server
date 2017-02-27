class GroupNeighborResource < BaseResource
  has_one :source
  has_one :destination

  filters :source, :destination
end
