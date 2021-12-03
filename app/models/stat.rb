class Stat < ApplicationRecord
  belongs_to :user

  validates :type, presence: true, uniqueness: { scope: :user_id }

  # Gets a user-specific instance of a stat, automatically generating it if it doesn't exist.
  # @return [Stat] the Stat for a user
  def self.for_user(user)
    Retriable.retriable(on: {
      ActiveRecord::RecordNotUnique => nil,
      ActiveRecord::RecordInvalid => /Type has already been taken/
    }, max_elapsed_time: 30) do
      where(user: user).first_or_initialize(&:recalculate!)
    end
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

  before_create do
    self.recalculated_at ||= Time.now
  end
end
