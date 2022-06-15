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

  def recalculate_total_length!
    update(total_length: episodes.length_total)
  end

  def unit(number)
    episodes.reorder(number: :asc).offset(number - 1).first if number >= 1
  end

  def default_progress_limit
    # Weekly with a margin
    run_length ? (run_length.to_i / 7) + 5 : 100
  end

  included do
    has_many :episodes, -> { order(number: :asc) },
      as: 'media',
      dependent: :destroy,
      inverse_of: 'media'
    accepts_nested_attributes_for :episodes, allow_destroy: true
    has_many :streaming_links, as: 'media', dependent: :destroy
    alias_attribute :progress_limit, :episode_count

    validates :episode_count, numericality: { greater_than: 0 }, allow_nil: true

    after_save do
      if saved_change_to_episode_length?
        episodes.where(length: nil).or(episodes.where(length: 0)).update_all(length: episode_length)
      end
    end
  end
end
