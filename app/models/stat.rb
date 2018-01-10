# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: stats
#
#  id         :integer          not null, primary key
#  stats_data :jsonb            not null
#  type       :string           not null, indexed => [user_id]
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null, indexed => [type], indexed
#
# Indexes
#
#  index_stats_on_type_and_user_id  (type,user_id) UNIQUE
#  index_stats_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_9e94901167  (user_id => users.id)
#
# rubocop:enable Metrics/LineLength

class Stat < ApplicationRecord
  belongs_to :user, required: true

  validates :type, presence: true, uniqueness: { scope: :user_id }

  # Gets a user-specific instance of a stat, automatically generating it if it doesn't exist.
  # @return [Stat] the Stat for a user
  def self.for_user(user)
    where(user: user).first_or_initialize(&:recalculate!)
  end

  # Provides an overridable place to set default structure for the stats
  # @return [#to_json] A JSON-serializable object to act as the default for the stat
  def default_data
    {}
  end

  # Resets the stored data to the default
  # @return [void]
  def reset_data
    self.stats_data = default_data
  end

  # Are all the default_data keys present in the current data?
  # @return [Boolean] whether the default keys are present
  def has_default_keys?
    (default_data.keys - stats_data.keys).empty?
  end

  before_validation :reset_data, unless: :stats_data
  after_find :recalculate!, unless: :has_default_keys?
end
