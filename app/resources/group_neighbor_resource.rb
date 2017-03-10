class GroupNeighborResource < BaseResource
  include GroupActionLogger

  has_one :source
  has_one :destination

  filters :source, :destination

  log_verb do |action|
    case action
    when :create then 'added_neighbor'
    when :remove then 'removed_neighbor'
    end
  end
  log_target :destination
  log_group :source
end
