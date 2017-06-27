class Badge
  include DSL

  def initialize(rank)
    @rank = rank
  end

  def id
    name = name.sub(/Badge\z/, '').underscore.dasherize
    [name, @rank].compact.join('/')
  end

  def rarity_service
    @rarity_service ||= Badge::RarityService.new(self)
  end
  delegate :rarity, to: :rarity_service
  delegate :percent, to: :rarity_service

  def self.progress_for(user)
    if _progress.nil?
      []
    else
      progress = user.instance_eval(&_progress) if _progress
      # Lambdas are picky about arity, so we need to make sure we match that.
      params = [progress].compact
      _ranks.map { |rank, fn| [rank, fn.call(*params)] }
    end
  end
end
