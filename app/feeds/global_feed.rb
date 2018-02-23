class GlobalFeed < Feed
  def initialize(*)
    super('global')
  end

  def read_target
    %w[global global]
  end

  def write_target
    nil
  end
end
