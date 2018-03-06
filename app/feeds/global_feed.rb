class GlobalFeed < Feed
  def initialize(future: false)
    super(future ? 'future' : 'global')
  end

  def read_target
    if Flipper.enabled?(:new_global)
      %w[global future]
    else
      %w[global global]
    end
  end

  def write_target
    ['global', id]
  end
end
