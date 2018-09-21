class GlobalStat < ApplicationRecord
  validates :type, presence: true, uniqueness: true
end
