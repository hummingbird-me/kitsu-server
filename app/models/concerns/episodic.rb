module Episodic
  extend ActiveSupport::Concern

  def recalculate_episode_length!
    # Try for the statistical mode (most common value) of episode lengths
    length, num = episodes.length_mode.values_at(:mode, :count)

    # use length if num is nil
    update(episode_length: length) if num.nil?
    return if num.nil?

    # If it's less than half of episodes, use average instead
    length = episodes.length_average if episode_count && num < (episode_count / 2)

    update(episode_length: length)
  end

  def unit(number)
    episodes.where(number: number).first
  end

  def default_progress_limit
    # Weekly with a margin
    run_length ? (run_length.to_i / 7) + 5 : 100
  end

  included do
    has_many :episodes, as: 'media', dependent: :destroy, inverse_of: 'media'
    has_many :streaming_links, as: 'media', dependent: :destroy
    alias_attribute :progress_limit, :episode_count

    validates :episode_count, numericality: { greater_than: 0 }, allow_nil: true
  end
end
