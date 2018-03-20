class GlobalFeed < Feed
  def read_target
    %w[global future]
  end

  def write_target
    %w[global future]
  end
end
