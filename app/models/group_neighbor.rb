class GroupNeighbor < ApplicationRecord
  belongs_to :source, class_name: 'Group', optional: false,
    counter_cache: 'neighbors_count'
  belongs_to :destination, class_name: 'Group', optional: false
end
