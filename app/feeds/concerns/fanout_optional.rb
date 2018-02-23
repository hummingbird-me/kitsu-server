module FanoutOptional
  def no_fanout
    @no_fanout = true
    self
  end

  def write_feed
    @no_fanout ? read_feed : super
  end
end
