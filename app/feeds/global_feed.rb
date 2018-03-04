class GlobalFeed < Feed
  def initialize(future: false)
    super(future ? 'future' : 'global')
  end

  def read_target
    %w[global global]
  end

  def write_target
    nil
  end
end
