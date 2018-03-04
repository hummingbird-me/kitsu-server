class GlobalFeed < Feed
  def initialize(future: false)
    super(future ? 'future' : 'global')
  end

  def read_target
    ['global', id]
  end

  def write_target
    ['global', id]
  end
end
