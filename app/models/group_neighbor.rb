class GroupNeighbor < ApplicationRecord
  belongs_to :source, class_name: 'Group', required: true,
                      counter_cache: 'neighbors_count'
  belongs_to :destination, class_name: 'Group', required: true
end
